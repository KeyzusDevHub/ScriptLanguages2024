# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List
import json
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import requests

def PrintTournament(name):
    details = f'Tournament {name} details:\n'
    with open('tournaments.json') as json_file:
        data = json.load(json_file)
        details += "Players:\n"
        for item in data["Tournaments"][name]["Players"]:
            details += "\t" + item + ". " + data["Tournaments"][name]["Players"][item] + "\n"
        details += f'Game state: {data["Tournaments"][name]["Current state"]}\n'
        details += 'Matches:\n'
        for item in data["Tournaments"][name]["Matches"]:
            details += "\t" + item + ". " + data["Tournaments"][name]["Matches"][item] + "\n"
    return details
    


class ListCompetition(Action):

    def name(self) -> Text:
        return "comp_list"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        message = "All eligible tournament names:\n"
        with open('tournaments.json') as json_file:
            data = json.load(json_file)
            for comp in data["Tournaments"]:
                if data["Tournaments"][comp]["Current state"] == "Enlisting":
                    message += comp + '\n'
        dispatcher.utter_message(text=message)
        
        return []
    
class ListAllData(Action):

    def name(self) -> Text:
        return "list_all_data"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        dispatcher.utter_message(text="Here is all tournament data I got:")
        with open('tournaments.json') as json_file:
            data = json.load(json_file)
            tournament_names = data["Tournaments"]
            for item in tournament_names:
                dispatcher.utter_message(text=f'{PrintTournament(item)}')
        
        return []

class Enlist(Action):

    def name(self) -> Text:
        return "enlist_complete"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        chosen_name = tracker.get_slot('tournament')
        payload = {'token': 'XXXXXX', 'user': f'{tracker.sender_id}'}
        r = requests.post('https://slack.com/api/users.info', data=payload)
        data_json = json.loads(r.content)
        username = data_json["user"]["profile"]["real_name"]
        data = None
        compname = "None"
        with open('tournaments.json') as json_file:
            data = json.load(json_file)
            tournament_names = data["Tournaments"]
            for item in tournament_names:
                if item.lower() == chosen_name.lower():
                    compname = item
                    idx = int(max(data["Tournaments"][item]["Players"])) + 1
                    data["Tournaments"][item]["Players"][str(idx)] = username
                    if idx % 2 == 1:
                        idx2 = int(max(data["Tournaments"][item]["Matches"])) + 1
                        data["Tournaments"][item]["Matches"][str(idx2)] = "TBD vs TBD. Winner: TBD"
        
        with open('tournaments.json', 'w') as json_file:
            json_object = json.dumps(data, indent=4)
            json_file.write(json_object)

        dispatcher.utter_message(text=f'Added {username} with number {idx} to tournament {compname}.\n')
        dispatcher.utter_message(text=f'{PrintTournament(compname)}')
        
        return []

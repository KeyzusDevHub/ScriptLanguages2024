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
        
        dispatcher.utter_message(text="Placeholder - ListAllData")
        
        return []

class Enlist(Action):

    def name(self) -> Text:
        return "enlist_complete"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        dispatcher.utter_message(text="Placeholder - Enlist")
        
        return []

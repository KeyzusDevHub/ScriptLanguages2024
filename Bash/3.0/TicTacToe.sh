board_status=('1' '2' '3' '4' '5' '6' '7' '8' '9')
current_turn="x"
current_turn_name="None"

start(){
    clear
    board_status=('1' '2' '3' '4' '5' '6' '7' '8' '9')
    echo 'Hello, user!'
    echo 'This is Tic Tac Toe game!'
    PvP
}

board(){
    clear
    echo "$current_turn_name turn"
    for i in {0..6}
    do
        index=$i/2
        index=$index*3
        if [ $(($i % 2)) -eq 0 ]; then
            for j in {0..6}
            do
                echo -n '-'
            done
            echo ''
        else
            for j in {0..2}
            do
                rindex=$index+$j
                echo -n '|'
                echo -n "${board_status[$rindex]}"
            done
            echo '|'
        fi
    done
    move
}

end_game(){
    read -p 'Would you like to play again (Y or N)? ' -n1 ans
    if [ "$ans" == "Y" ]; then
        start
    elif [ "$ans" == "N" ]; then
        clear
        exit
    else
        clear
        echo "Wrong symbol"
        end_game
    fi
}

change_turn(){
    if [ $current_turn == "x" ]; then
        current_turn="o"
    else
        current_turn="x"
    fi

    if [ $current_turn_name == $name1 ]; then
        current_turn_name=$name2
    else
        current_turn_name=$name1
    fi
}

check_win(){
    for i in {0..2}
    do
        if [[ ${board_status[$i*3]} == ${board_status[$i*3+1]} && ${board_status[$i*3+1]} == ${board_status[$i*3+2]} && $((${board_status[$i*3]} == "x" || ${board_status[$i*3]} == "o")) ]]; then
            clear
            echo "$current_turn_name wins"
            end_game
        elif [[ ${board_status[$i]} == ${board_status[$i+3]} && ${board_status[$i+3]} == ${board_status[$i+6]} && $((${board_status[$i]} == "x" || ${board_status[$i]} == "o")) ]]; then
            clear
            echo "$current_turn_name wins"
            end_game
        elif [[ ${board_status[0]} == ${board_status[4]} && ${board_status[4]} == ${board_status[8]} && $((${board_status[0]} == "x" || ${board_status[0]} == "o")) ]]; then
            clear
            echo "$current_turn_name wins"
            end_game
        elif [[ ${board_status[2]} == ${board_status[4]} && ${board_status[4]} == ${board_status[6]} && $((${board_status[2]} == "x" || ${board_status[2]} == "o")) ]]; then
            clear
            echo "$current_turn_name wins"
            end_game
        fi
    done
    for i in {0..8}
    do
        if [[ ${board_status[$i]} != 'x' && ${board_status[$i]} != 'o' ]]; then
            return
        fi
    done
    clear
    echo "Tie"
    end_game
}

move(){
    if [ $versus_computer = 0 ]; then
        read -p "Chose empty field number (1-9): " -n1 ans
        if [ $ans -eq ${board_status[$ans-1]} ]; then
            board_status[$ans-1]=$current_turn
            check_win
            change_turn
        else
            clear
            echo "You entered wrong number."
            board
            move
        fi
    fi
    board
}

PvP(){
    read -p "Enter first player name: " name1
    read -p "Enter second player name: " name2
    if [[ $name1 == "" ]]; then
        name1="Player1"
    fi
    if [[ $name2 == "" ]]; then
        name2="Player2"
    fi
    starts=$RANDOM
    if [[ $(($starts % 2)) == 0 ]]; then
        current_turn_name=$name1
    else
        current_turn_name=$name2
    fi
    board
}

start

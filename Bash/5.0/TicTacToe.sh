board_status=('1' '2' '3' '4' '5' '6' '7' '8' '9')
current_turn="x"
current_turn_name="None"

start(){
    clear
    board_status=('1' '2' '3' '4' '5' '6' '7' '8' '9')
    echo 'Hello, user!'
    echo 'This is Tic Tac Toe game!'
    if [ -f ./save.data ]; then
        read -p 'Would you like to play PvP (press 1), PvE (press 2) or restore last game (press R)? ' -n1 ans
    else
        read -p 'Would you like to play PvP (press 1) or PvE (press 2)? ' -n1 ans
    fi
    
    echo ""

    if [ "$ans" == "1" ]; then
        PvP;
    elif [ "$ans" == "2" ]; then
        PvE;
    elif [ "$ans" == "R" ]; then
        load
        board
    else
        start
    fi
}

save(){
    echo ${board_status[0]} > ./save.data
    for i in {1..8}
    do
        echo ${board_status[$i]} >> ./save.data
    done
    echo $name1 >> ./save.data
    echo $name2 >> ./save.data
    echo $current_turn >> ./save.data
    echo $current_turn_name >> ./save.data
}

load(){
    index=0
    while IFS= read -r line
    do
        if [ $index -lt 9 ]; then
            board_status[$index]=$line
        elif [ $index -eq 9 ]; then
            name1=$line
        elif [ $index -eq 10 ]; then
            name2=$line
        elif [ $index -eq 11 ]; then
            current_turn=$line
        elif [ $index -eq 12 ]; then
            current_turn_name=$line
        fi
        index=$((index+1))
    done < ./save.data
}


board(){
    save
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
    if [ -f ./save.data ]; then
        rm ./save.data
    fi
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
    check_win
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
    board
}

try_attack_block(){
    for i in {0..2}
    do
        if [[ ${board_status[$(($i*3))]} == ${board_status[$(($i*3+1))]} && ${board_status[$(($i*3+1))]} == $current_check && ${board_status[$(($i*3+2))]} == $(($i*3+3)) ]]; then
            board_status[$(($i*3+2))]=$current_turn
            change_turn
        elif [[ ${board_status[$i*3]} == ${board_status[$(($i*3+2))]} && ${board_status[$(($i*3+2))]} == $current_check && ${board_status[$(($i*3+1))]} == $(($i*3+2)) ]]; then
            board_status[$(($i*3+1))]=$current_turn
            change_turn
        elif [[ ${board_status[$i*3+1]} == ${board_status[$(($i*3+2))]} && ${board_status[$(($i*3+2))]} == $current_check && ${board_status[$(($i*3))]} == $(($i*3+1)) ]]; then
            board_status[$(($i*3))]=$current_turn
            change_turn
        elif [[ ${board_status[$i]} == ${board_status[$(($i+3))]} && ${board_status[$(($i+3))]} == $current_check && ${board_status[$(($i+6))]} == $(($i+7)) ]]; then
            board_status[$(($i+6))]=$current_turn
            change_turn
        elif [[ ${board_status[$i]} == ${board_status[$(($i+6))]} && ${board_status[$(($i+6))]} == $current_check && ${board_status[$(($i+3))]} == $(($i+4)) ]]; then
            board_status[$(($i+3))]=$current_turn
            change_turn
        elif [[ ${board_status[$i+3]} == ${board_status[$(($i+6))]} && ${board_status[$(($i+6))]} == $current_check && ${board_status[$i]} == $(($i+1)) ]]; then
            board_status[$i]=$current_turn
            change_turn
        fi
    done
    if [[ ${board_status[0]} == ${board_status[4]} && ${board_status[4]} == $current_check && ${board_status[8]} == 9 ]]; then
        board_status[8]=$current_turn
        change_turn
    elif [[ ${board_status[0]} == ${board_status[8]} && ${board_status[8]} == $current_check && ${board_status[4]} == 5 ]]; then
        board_status[4]=$current_turn
        change_turn
    elif [[ ${board_status[4]} == ${board_status[8]} && ${board_status[8]} == $current_check && ${board_status[0]} == 1 ]]; then
        board_status[2]=$current_turn
        change_turn
    elif [[ ${board_status[2]} == ${board_status[4]} && ${board_status[4]} == $current_check && ${board_status[6]} == 7 ]]; then
        board_status[6]=$current_turn
        change_turn
    elif [[ ${board_status[2]} == ${board_status[6]} && ${board_status[6]} == $current_check && ${board_status[4]} == 5 ]]; then
        board_status[4]=$current_turn
        change_turn
    elif [[ ${board_status[4]} == ${board_status[6]} && ${board_status[4]} == $current_check && ${board_status[2]} == 3 ]]; then
        board_status[2]=$current_turn
        change_turn
    fi
}

half_random_move(){
    if [[ ${board_status[4]} == 5 ]]; then
        board_status[4]=$current_turn
        change_turn
    elif [[ ${board_status[0]} == 1 ]]; then
        board_status[0]=$current_turn
        change_turn
    elif [[ ${board_status[2]} == 3 ]]; then
        board_status[2]=$current_turn
        change_turn
    elif [[ ${board_status[6]} == 7 ]]; then
        board_status[6]=$current_turn
        change_turn
    elif [[ ${board_status[8]} == 9 ]]; then
        board_status[8]=$current_turn
        change_turn
    fi
    for i in {0..8}
    do
        if [[ ${board_status[$i]} == $(($i+1)) ]]; then
            board_status[$i]=$current_turn
            change_turn
        fi
    done
    echo "Here"
}

computer_move(){
    current_check=$current_turn
    try_attack_block
    if [[ $current_turn == 'x' ]]; then
        current_check='o'
    else
        current_check='x'
    fi
    try_attack_block
    half_random_move
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
    if [ $name2 != "Computer" ]; then
        read -p "Chose empty field number (1-9): " -n1 ans
        if [ $ans -eq ${board_status[$ans-1]} ]; then
            board_status[$ans-1]=$current_turn
            change_turn
        else
            clear
            echo "You entered wrong number."
            board
            move
        fi
    else
        if [ $current_turn_name != "Computer" ]; then
            read -p "Chose empty field number (1-9): " -n1 ans
            if [ $ans -eq ${board_status[$ans-1]} ]; then
                board_status[$ans-1]=$current_turn
                change_turn
            else
                clear
                echo "You entered wrong number."
                board
                move
            fi
        else
            computer_move
        fi
    fi
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

PvE(){
    read -p "Enter your name: " name1
    if [[ $name1 == "" ]]; then
        name1="Player1"
    fi
    name2="Computer"
    starts=$RANDOM
    if [[ $(($starts % 2)) == 0 ]]; then
        current_turn_name=$name1
    else
        current_turn_name=$name2
    fi
    board
}

start

#!/bin/bash

COLORS=('R' 'B' 'Y' 'G' 'P' 'V')

setup () {
    cp script.sql game_with_answer.sql
    for s in K1 K2 K3 K4
    do
        idx=$(( $RANDOM % 6 ))
        color=${COLORS[$idx]}
        sed -i.bak s/$s/$color/g game_with_answer.sql
    done
}

guess () {
    if ! [ -f game_with_answer.sql ]
    then
        echo "No game file! Run setup first."
        exit 1
    fi

    rm -f game_this_guess.sql
    cp game_with_answer.sql game_this_guess.sql


    for s in Z1 Z2 Z3 Z4
    do
        color=$1; shift
        if ! echo "$color" | grep -E -q '[RBYGPV]'
        then
            echo "Invalid color $color!"
            exit 1
        fi

        sed -i.bak s/$s/$color/g game_this_guess.sql
    done

    sqlite3 test.db < game_this_guess.sql
}

main () {
    com="$1"; shift
    if [[ "$com" == "setup" ]]
    then
        setup
    elif [[ "$com" == "guess" ]]
    then
        guess "$@"
    else
        echo "USAGE: $0 [ setup | guess C C C C]"
        exit 0
    fi
}

main "$@"
#setup
#guess R R R R

## TODO fix paths
#sqlite3 test.db < script.sql

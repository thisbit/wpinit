#!/bin/bash
#title:         menu.sh
#description:   Menu which allows multiple items to be selected
#author:        Nathan Davieau
#               Based on script from MestreLion
#created:       May 19 2016
#updated:       N/A
#version:       1.0
#usage:         ./menu.sh
#==============================================================================

#Menu options
options[0]="wp rig"
options[1]="_s"

#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[0]} ]]; then
        #Option 1 selected
	    wget https://github.com/wprig/wprig/archive/master.zip
    fi
    if [[ ${choices[1]} ]]; then
        #Option 2 selected
		wget https://github.com/Automattic/_s/archive/master.zip
    fi
}

#Variables
ERROR=" "

#Clear screen for menu
clear

#Menu function
function MENU {
    echo "Menu Options"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
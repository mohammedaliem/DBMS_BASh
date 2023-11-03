#!/bin/bash

. ./function.sh

export LC_COLLATE=C
shopt -s extglob






select choice in  "delete database" "Back to mainmenu" "Exit" 
do
    case $REPLY in 
        1)
             deletedatabase
             ;; 
        2) 
             mainmenu
             ;;
        3)
             Exit
             ;;
    esac 
done

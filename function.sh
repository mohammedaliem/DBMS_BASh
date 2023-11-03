#!/bin/bash

export LC_COLLATE=C
shopt -s extglob

Cyan='\033[1;36m'	          # Cyan Color Code
Blue='\033[1;34m'	          # Blue Color code 
Yellow='\033[1;33m'	        # Yellow Color code
RED='\033[1;31m'	          # Red Color code 
Green='\033[1;32m'	        # Green Color Green
ColorReset='\033[0m' 		    # No Color Code

function drawLogo() 
{
    
echo -e "${RED}"

cat << "EOF"

  _____  ____  __  __  _____ 
 |  __ \|  _ \|  \/  |/ ____|
 | |  | | |_) | \  / | (___  
 | |  | |  _ <| |\/| |\___ \ 
 | |__| | |_) | |  | |____) |
 |_____/|____/|_|  |_|_____/ 
                              
EOF
echo -e "${ColorReset}"

}

function logo(){
  echo -e "${RED}Loading.."
  sleep 2
    progress-bar 5
    resetColor
    clear

    # Draw Our Logo (DBMS)
    drawLogo
    
}


#------------------------------------------------------------------------------------------------
#mainmenu form here we should start



function mainmenu(){
# echo "welcome to main menu of data base"
logo
select choice in  "Create New Database" "Show Databases" "Use Database" "Delete Database" "quit"
do
    case $REPLY in 
        1)
        . ./createDB.sh
          ;; 
        2) 
        . ./showDB.sh 
          ;;
        3)
         . ./useDB.sh 
          ;;
        4) 
        . ./deleteDB.sh
          ;;
        5)
            exit
          ;; 
    esac 
done
}
#-----------------------------------------------------------
#create new database

createDB() {
var='!@#$%^&*()'
echo "enter name of new Database name" 
    read name 
        if  [ -d databases/$name ]; then
             echo -e "${RED}this database is already exist ${ColorReset}"
              createDB
              break
        elif [[ $name =~ [$var] ]];  then
             echo -e "${RED}database can't have regex ${ColorReset}"
              createDB
        else
             mkdir databases/$name
             mkdir databases/$name/.metadata
             echo -e "${Green} database created sucsessfully${ColorReset}" 
             mainmenu
        fi
}
#--------------------------------------------------------------
#backmenu
function backmenu(){
select choice in  "Create New Database" "Back to mainmenu" "Exit" 
do
    case $REPLY in 
        1)
             createDB
             ;; 
        2) 
             mainmenu
             ;;
        3)
             exit
             ;;
    esac 
done
}

#-----------------------------------------------------------------------------------
#deletedatabase


function deletedatabase(){

while true
do
ls databases
echo -e "${Cyan}enter database that you want to delete : ${ColorReset}"
read name 
     
if [ -e databases/$name ]; then

     rm -r databases/$name
     echo -e "${Green}successful delete database $name ${ColorReset}"
     mainmenu
     break

else  
    echo -e "${RED}database not found ${ColorReset}"
fi
done
}

#--------------------------------------------------------
#show databases

function listdatabases() {
dir=databases
if [ "$(ls -A $dir)" ]; then
    ls $dir
    mainmenu
    return 0
else 
    echo "No $dir exist"
    mainmenu
    return 1
fi
}

#-------------------------------------------------------------
# this function for meni for tables
function main_menu_table(){
select choice in  "show tables" "create new table" "insert into table" "Delete table" "update table" "select from tables" "return to main menu"
do
    case $REPLY in 
        1)
        . ./showtables.sh 
          ;; 
        2) 
        . ./createtable.sh 
          ;;
        3)
         . ./insert.sh 
          ;;
        4) 
        . ./deletetable.sh
          ;;
        5)
         . ./updatetable.sh
          ;; 
        6)
         . ./selecttables.sh
          ;;
        7)
         . ./mainmenu.sh
    esac 
done
}
#----------------------------------------------------------------------------
#this function for connect to databases 

function useDB(){
  listt
  while true 
  do
  echo "enter your database you want to access"
  read myDB
  if [[ -d databases/$myDB  ]]; then
     echo "database is selsected $myDB"
    #  cd databases/$myDB
      main_menu_table $myDB
      break

  else
     echo "Database does not exist."
      # mainmenu

  fi
  done
}


#---------------------------------------------------------------------

#delete table
function deletetable(){

    listt
    read  -p "enter you databasename " name
    ls databases/$name
    read  -p  "Enter Table Name " table 

    if [[ -e databases/$name/$table ]]; then 
        
        rm   databases/$name/$table
        echo "$table Table  deleted Successfully"
    else 
        echo "No such Table"
    fi

}
#-------------------------------------------------------------------------------

#this function to list tables

function listtables(){
# listdatabases
# read -p "echo enter your database name " name

if [ -n "$(ls -A databases/$1/)" ]; then
        echo  "available tables"
         ls databases/$1/
         main_menu_table $1
         return 0
else
    echo "no tables to show "
    return 1
fi
}
#-----------------------------------------------------
#functions  to create table
function taplenameconstrain(){
var='!@#$%^&*()'
if [ $? -eq 0 ]; then 
  while true;
  do 
  if [ -e databases/$1  ]; then
    break
  else
      echo "database doesnt exist"
  fi
  done
  while true;
  do
  read -p "enter your table name " table
  if  [[  $table =~ [0-9]+$ ]]; then
          echo " ERROR name of table can not contain number"
          
  elif
      [[ $table =~ [$var] ]];  then
          echo " ERROR name of table can't have regex"
          
  elif
      [[ -z "$table" ]];  then
          echo "ERROR table can't be empty"
          
  elif 
      [[  $table = *" "* ]];  then
          echo "ERROR table can't contain spaces"
  
  else 
      touch databases/$1/$table
      touch databases/$1/.metadata/$table.meta
      chmod 777 databases/$1/.metadata/$table.meta
      chmod 777 databases/$1/$table
      createcolumn databases/$1/.metadata/$table.meta
      
      main_menu_table $1
  fi
  done
elif [ $? -eq 1 ]; then
  mainmenu
fi
}

function createcolumn(){
  declare -i coloumnnumber
   while true;
   do
    read -p "enter the number of coloumn " coloumnnumber
    if [[ $coloumnnumber =~ ^[0-9]+$ ]]; then
      break
    else
        echo "column number cannot be empty or string"
    fi
    done

    for (( i = 1 ; i <= $coloumnnumber ; i++ ))
    do
        while true;
        do
            read -p "enter column name " cn
            if [[ -z $cn ]]  || [[ ! $cn =~ ^[a-zA-Z]+[a-zA-Z0-9]*$  ]]; then
                echo "column field must be charachters only"
            else
                break
            fi
        done
        if (( $i == $coloumnnumber)); then
            echo "$cn;" >> $1 
            echo "Table created succefully"
            break
        elif (( $i < $coloumnnumber)); then
            echo -e "$cn;" >> $1 
        fi 
    done
}
#--------------------------------------------------------------------------
#insert function
function insert(){
  var='!@#$%^&*()'
  while true;
  do 
  listt $1
  read -p "enter your table want to access " table
  if [ -e databases/$1/$table  ]; then
    
    break
  else
      echo "table doesnt exist"
  fi
  done
  
  for (( i = 1 ; i <= "$(cat databases/$1/.metadata/$table.meta | wc -l)" ; i++ )) 
  do
    while true;
    do
      read -p "enter your value " value
      if [[ $value =~ [$var] ]];  then
          echo " ERROR name of column can't have regex"

      elif [[ -z "$value" ]];  then
            echo "ERROR column can't be empty"
          
          
      elif [[  $value = *" "* ]];  then
          echo "ERROR column can't contain spaces" 
      else 
        break
      fi
      done
      if (( $i == "$(cat databases/$1/.metadata/$table.meta | wc -l)" )); then
            echo "$value" >> databases/$1/$table
            echo "insert is done"
            main_menu_table $1
            break
      elif (( $i < "$(cat databases/$1/.metadata/$table.meta | wc -l)" )); then
            echo -e "$value;\c" >>  databases/$1/$table
      fi 

  done
}


function listt(){
ls databases/$1 
}
#-----------------------------------------------------------------------
# this function for select databases 

function selecttables(){
    listt $1
    while true;
    do 
    read -p "Enter the table you want to select from: " table
    if [ -e databases/$1/$table  ]; then
        cat databases/$1/$table   
        echo ""
        main_menu_table $1
        break
    else
        echo -e "${RED}table doesnt exist ${ColorReset}"
    fi
    done
}


function updatetable(){
 while true;
  do 
  listt $1
  read -p "enter your table want to access " table
  if [ -e databases/$1/$table  ]; then
    break
  else
      echo "table doesnt exist"
  fi
  done
  read -p "Enter the value you want to change: " old_column_value
  read -p "Enter your value you want to add: " new_column_value
  sed -i "s/$old_column_value/$new_column_value/g" databases/$1/$table   
}

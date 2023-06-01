#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
else
  # check atomic_number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_RESULTS=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e INNER JOIN properties AS p ON e.atomic_number = p.atomic_number INNER JOIN types AS t ON p.type_id = t.type_id WHERE e.atomic_number = $1")
    if [[ -z $ELEMENT_RESULTS ]]
    then
      echo -e "I could not find that element in the database."  
    else
      echo "$ELEMENT_RESULTS" | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTING BAR BOILING
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  else
    # check symbol or name
    ELEMENT_RESULTS=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e INNER JOIN properties AS p ON e.atomic_number = p.atomic_number INNER JOIN types AS t ON p.type_id = t.type_id WHERE lower(e.symbol) = LOWER('$1') OR LOWER(e.name) = LOWER('$1')")
    if [[ -z $ELEMENT_RESULTS ]]
    then
      echo -e "I could not find that element in the database."  
    else
      echo "$ELEMENT_RESULTS" | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTING BAR BOILING
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
fi

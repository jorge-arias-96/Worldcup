#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
echo -e "\n~~Welcome to the insert data script~~\n"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  #Add winner to teams table
  if [[ $WINNER != winner ]]
  then
    TEAM_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_WINNERS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
  fi
  #Add opponent to teams table
  if [[ $OPPONENT != opponent ]]
  then
    OPP_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPP_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    fi
  fi

  #Add one row
  if [[ $OPPONENT_GOALS != opponent_goals || $YEAR != year || $ROUND != round || $WINNER_GOALS != winner_goals ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_ROW=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES ($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS)")
  fi

done

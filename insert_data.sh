#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

#Read games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $WINNER != winner ]] 
	then
		#get winner id
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		#if no data 
		if [[ -z $WINNER_ID ]]
		then
			NEW_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			# if inserted success
			if [[ $NEW_WINNER_ID == "INSERT 0 1" ]]
			then
				echo "insert team name :"$WINNER
				WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
			fi
		fi
	fi
	
	if [[ $OPPONENT != opponent ]] 
	then
		#get winner id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
		#if no data 
		if [[ -z $OPPONENT_ID ]]
		then
			NEW_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			# if inserted success
			if [[ $NEW_OPPONENT_ID == "INSERT 0 1" ]]
			then
				echo "insert team name :"$OPPONENT
				OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
			fi
		fi
	fi
	
	if [[ $YEAR != year ]] 
	then
		GAMES_ID=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    # if inserted success
		if [[ $GAMES == "INSERT 0 1" ]]
			then
				echo New game added: $YEAR, $ROUND, $WINNER VS $OPPONENT, score $WINNER_GOALS : $OPPONENT_GOALS
			fi
	fi
	
done
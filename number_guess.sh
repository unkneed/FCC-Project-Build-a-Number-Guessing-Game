#!/bin/bash
PSQL='psql --username=freecodecamp --dbname=number_guess -t --no-align -c'
RANDOM_NUMBER=$(( 1 + RANDOM % 1000 ))
MAIN_MENU() {
 echo $1
 echo "Enter your username:"
 read USERNAME_INPUT
}
MAIN_MENU
USERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME_INPUT'")
if [[ ${#USERNAME_INPUT} -gt 22 ]]
then
  MAIN_MENU 'Try again, please insert a username less than 22 characters.'
elif [[ -z $USERNAME ]]
then
  NEW_USERNAME_INSERTED=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME_INPUT')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME_INPUT'")
  echo "Welcome, $USERNAME_INPUT! It looks like this is your first time here."
else
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id = $USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
NUMBER_OF_GUESSES=0
GAME_MENU() {
  echo $1
  read NUMBER_GUESSED
if [[ ! $NUMBER_GUESSED =~ ^[0-9]+$ ]]
then
  GAME_MENU "That is not an integer, guess again:"
elif [[ $NUMBER_GUESSED > $RANDOM_NUMBER ]]
then
  (( NUMBER_OF_GUESSES++ ))
  GAME_MENU "It's lower than that, guess again:"
elif [[ $NUMBER_GUESSED < $RANDOM_NUMBER ]]
then
  (( NUMBER_OF_GUESSES++ ))
  GAME_MENU "It's higher than that, guess again:"
else
  (( NUMBER_OF_GUESSES++ ))
  INSERTED_GAME_RECORD=$($PSQL "INSERT INTO games(number_of_guesses, user_id) VALUES($NUMBER_OF_GUESSES, $USER_ID)")
  echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi
}
GAME_MENU "Guess the secret number between 1 and 1000:"

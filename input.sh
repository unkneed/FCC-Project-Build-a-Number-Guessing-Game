#!/bin/bash
mkdir number_guessing_game
cd number_guessing_game
touch number_guess.sh
chmod +x number_guess.sh
echo "#!/bin/bash" >> number_guess.sh

###Database Inputs probably need commands to enter and exit###
psql --username=freecodecamp --dbname=postgres <<EOF
CREATE DATABASE number_guess;
\c number_guess
CREATE TABLE users(user_id SERIAL PRIMARY KEY, username VARCHAR(22) UNIQUE NOT NULL);
CREATE TABLE games(game_id SERIAL PRIMARY KEY, number_of_guesses INT NOT NULL, user_id INT NOT NULL);
ALTER TABLE games ADD FOREIGN KEY(user_id) REFERENCES users(user_id);
\q
EOF

###Git Repo###
#Commit 0 - Initial Commit
git init
git checkout -b main
        #####ADDING CONTENT#####
echo "PSQL='psql --username=freecodecamp --dbname=number_guess -t --no-align -c'" >> number_guess.sh
  #Generate a random number
echo -e "RANDOM_NUMBER=\$(( 1 + RANDOM % 1000 ))" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "Initial commit"


#Commit 1: feat: Added username prompt menu
echo checkout -b feat/added-username-prompt-menu
        #####ADDING CONTENT#####
echo "MAIN_MENU() {" >> number_guess.sh
echo -e " echo \$1" >> number_guess.sh
echo -e " echo \"Enter your username:\"" >> number_guess.sh
echo " read USERNAME_INPUT" >> number_guess.sh
echo "}" >> number_guess.sh
echo "MAIN_MENU" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added username prompt menu"
git checkout main
git merge feat/added-username-prompt-menu
git branch -d feat/added-username-prompt-menu


#Commit 2: feat: Added out of bounds username handler
git checkout -b feat/added-out-of-bounds-username-handler
        #####ADDING CONTENT#####
echo -e "USERNAME=\$(\$PSQL \"SELECT username FROM users WHERE username = '\$USERNAME_INPUT'\")" >> number_guess.sh
echo "if [[ \${#USERNAME_INPUT} -gt 22 ]]" >> number_guess.sh 
echo "then" >> number_guess.sh
echo "  MAIN_MENU 'Try again, please insert a username less than 22 characters.'" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added out of bounds username handler"
git checkout main
git merge feat/added-out-of-bounds-username-handler
git branch -d feat/added-out-of-bounds-username-handler


#Commit 3 - feat: Added input new user
git checkout -b feat/added-input-new-user
        #####ADDING CONTENT#####
echo "elif [[ -z \$USERNAME ]]" >> number_guess.sh
echo "then" >> number_guess.sh
echo -e "  NEW_USERNAME_INSERTED=\$(\$PSQL \"INSERT INTO users(username) VALUES('\$USERNAME_INPUT')\")" >> number_guess.sh
echo -e "  USER_ID=\$(\$PSQL \"SELECT user_id FROM users WHERE username = '\$USERNAME_INPUT'\")" >> number_guess.sh
echo -e "  echo \"Welcome, \$USERNAME_INPUT! It looks like this is your first time here.\"" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added input new user"
git checkout main
git merge feat/added-input-new-user
git branch -d feat/added-input-new-user


#Commit 4 - feat: Added welcome existing user
git checkout -b feat/added-welcome-existing-user
        #####ADDING CONTENT#####
echo "else" >> number_guess.sh
echo -e "  USER_ID=\$(\$PSQL \"SELECT user_id FROM users WHERE username = '\$USERNAME'\")" >> number_guess.sh
echo -e "  GAMES_PLAYED=\$(\$PSQL \"SELECT COUNT(*) FROM games WHERE user_id = \$USER_ID\")" >> number_guess.sh
echo -e "  BEST_GAME=\$(\$PSQL \"SELECT MIN(number_of_guesses) FROM games WHERE user_id = \$USER_ID\")" >> number_guess.sh
echo -e "  echo \"Welcome back, \$USERNAME! You have played \$GAMES_PLAYED games, and your best game took \$BEST_GAME guesses.\"" >> number_guess.sh
echo "fi" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added welcome existing user"
git checkout main
git merge feat/added-welcome-existing-user
git branch -d feat/added-welcome-existing-user


#Commit 5 - feat: Added number guessing game menu
git checkout -b feat/added-number-guessing-game-menu
        #####ADDING CONTENT#####
echo "NUMBER_OF_GUESSES=0" >> number_guess.sh
echo "GAME_MENU() {" >> number_guess.sh
echo "  echo \$1" >> number_guess.sh
echo "  read NUMBER_GUESSED" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added number guessing game menu"
git checkout main
git merge feat/added-number-guessing-game-menu
git branch -d feat/added-number-guessing-game-menu


#Commit 6 - feat: Added response to bad input
git checkout -b feat/added-response-to-bad-input
        #####ADDING CONTENT#####
echo "if [[ ! \$NUMBER_GUESSED =~ ^[0-9]+$ ]]" >> number_guess.sh
echo "then" >> number_guess.sh
echo -e "  GAME_MENU \"That is not an integer, guess again:\"" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added response to bad input"
git checkout main
git merge feat/added-response-to-bad-input
git branch -d feat/added-response-to-bad-input


# Commit 7 - feat: Added response to higher or lower numbers
git checkout -b feat/added-response-to-higher-or-lower-numbers
        #####ADDING CONTENT#####
echo "elif [[ \$NUMBER_GUESSED > \$RANDOM_NUMBER ]]" >> number_guess.sh
echo "then" >> number_guess.sh
echo "  (( NUMBER_OF_GUESSES++ ))" >> number_guess.sh
echo -e "  GAME_MENU \"It's lower than that, guess again:\"" >> number_guess.sh
echo "elif [[ \$NUMBER_GUESSED < \$RANDOM_NUMBER ]]" >> number_guess.sh
echo "then" >> number_guess.sh
echo "  (( NUMBER_OF_GUESSES++ ))" >> number_guess.sh
echo -e "  GAME_MENU \"It's higher than that, guess again:\"" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added response to higher or lower numbers"
git checkout main
git merge feat/added-response-to-higher-or-lower-numbers
git branch -d feat/added-response-to-higher-or-lower-numbers


#Commit 8 - feat: Added congratulation statement
git checkout -b feat/added-congratulation-statement
        #####ADDING CONTENT#####
echo "else" >> number_guess.sh
echo "  (( NUMBER_OF_GUESSES++ ))" >> number_guess.sh
echo -e "  INSERTED_GAME_RECORD=\$(\$PSQL \"INSERT INTO games(number_of_guesses, user_id) VALUES(\$NUMBER_OF_GUESSES, \$USER_ID)\")" >> number_guess.sh
echo -e "  echo \"You guessed it in \$NUMBER_OF_GUESSES tries. The secret number was \$RANDOM_NUMBER. Nice job!\"" >> number_guess.sh
echo "fi" >> number_guess.sh
echo "}" >> number_guess.sh
echo -e "GAME_MENU \"Guess the secret number between 1 and 1000:\"" >> number_guess.sh
        #####ADDING CONTENT#####
git add .
git commit -m "feat: Added congratulation statement"
git checkout main
git merge feat/added-congratulation-statement
git branch -d feat/added-congratulation-statement


#!/bin/sh
#
# Eddy Wong
# eddy.wong@datastax.com
# created: Mar 24, 2021
#  - modified May 25, 2022: Artemis related and Graph Analytics
#  - updated: Jul 13, 2022: Streamline, changed to killrvideo (all lowercase)

# Loads csv files to a graph/keyspace
#
# Usage
#
# load_csv.sh [target graph] 
#
# Examples:
# > load_csv.sh killrvideo
# 
# > load_csv.sh

DSBULK_HOME=/home/automaton/dsbulk/dsbulk-1.8.0/
DSBULK_EXE=$DSBULK_HOME/bin/dsbulk

# Hardcoding to my dev server
HOST=54.187.156.75
PORT=9042

# Astra
#  Dsbulk upload csv
# /Users/eddy.wong/programs/dsbulk-1.8.0/bin/dsbulk load 
# -url /Users/eddy.wong/workspace/datastax/astra/bank/Account.csv 
# -k bank -t "Account" 
# -b /Users/eddy.wong/keys/secure-connect-ds5-poc.zip 
# -u user
# -p password
# -header true

#DSBULK_HOME=/Users/eddy.wong/programs/dsbulk-1.8.0/
DSBULK_EXE=$DSBULK_HOME/bin/dsbulk

BUNDLE=/Users/eddy.wong/keys/secure-connect-ds5-poc-plus.zip
#USERNAME=user
#PASSWORD=password
USERNAME=test
PASSWORD=test


# GRAPH is the graph/keyspace to load to
GRAPH=$1

if [ -z "$GRAPH" ]; then
    	#echo "Base dir must be provided"
	# Setting detault to 'killrvideo'
	GRAPH=killrvideo
fi

# Define your dsbwrap function here
dsbwrap () {
   echo "$DSBULK_EXE load -h $HOST -p $PORT -g $GRAPH $1 $2 $3 $4 $5 $6 $7 $8 $9 $10"
   $DSBULK_EXE load -h $HOST -p $PORT -g $GRAPH $1 $2 $3 $4 $5 $6 $7 $8 -header true
   return 10
}

# Define your dsbc_wrapfunction here
dsbc_wrap () {
   echo "$DSBULK_EXE load -h $HOST -p $PORT -b $BUNDLE -u $USERNAME -p $PASSWORD $1 $2 $3 $4 $5 $6 $7 $8"
   echo "$DSBULK_EXE load -h $HOST -p $PORT -b $BUNDLE -u $USERNAME -p $PASSWORD $1 $2 $3 $4 $5 $6 $7 $8"
   return 10
}


#echo "$DSBULK_EXE load -b $BUNDLE -u $USERNAME -p $PASSWORD -g $GRAPH -v "Account" -url Account.csv  -header true"

#dsbwrap -g $GRAPH -e "actor" -from movie -to person -url actors.csv  -header true

dsbwrap -g $GRAPH -v genre -url genres.csv -header true
dsbwrap -g $GRAPH -v person -url persons.csv -header true
dsbwrap -g $GRAPH -v user -url users.csv -header true
dsbwrap -g $GRAPH -v movie -url movies.csv -header true

dsbwrap -e actor -from movie -to person -url actors.csv
dsbwrap -e knows -from user -to user -url knows.csv
dsbwrap -e rated -from user -to movie -url rated.csv
dsbwrap -e belongsTo -from movie -to genre -url belongsto.csv
dsbwrap -e director -from movie -to person -url directors.csv


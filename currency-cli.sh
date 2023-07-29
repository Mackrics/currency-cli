#!/usr/bin/mksh

# The simple currency script ---------------------------------------------------

# Assert input ---
if [[ $1 == "-h" ]] ; then # Print help message
	cat $(realpath "$0") # Print sourcecode
	exit
fi

if [[ $1 == "" || $2 == "" || $3 == "" ]] ; then # point toward documentation
	echo "Missing arguments. See ./currency-cli.sh -h"
	exit
fi

# Parameters ---
AMOUNT=$(echo $1) # Amount to convert
FROM=$(echo $2 | tr '[:lower:]' '[:upper:]') # From currency (all upper)
TO=$(echo $3 | tr '[:lower:]' '[:upper:]') # To currency (all upper)

# Fetch latest rate ----
value=$(curl $(echo "https://api.frankfurter.app/latest?amount=$AMOUNT&from=$FROM&to=$TO" --silent) | 
	jq | 
	grep $TO | 
	awk '{print $2}'
)

# Print output
if [[ $value == "" ]] ; then # Failed to fetch the exchange rate
	echo "Something went wrong: check the arguments."
else # Print the exchange rate
	echo "$AMOUNT $FROM is $value $TO."
fi

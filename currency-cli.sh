#!/usr/bin/mksh
#------------------- Set variables -----------------------------------------#
if [[ $1 == "-h" ]] ; then
	echo "usage: ./currency-cli.sh AMOUNT FROM TO" # Feel free to change this default
	exit
fi

if [[ $1 == "" || $2 == "" || $3 == "" ]] ; then
	echo "Missing arguments. See ./currency-cli.sh -h"
	exit
fi

# assign variables for radability
AMOUNT=$(echo $1)
# all currencies must be UPPERCASE
FROM=$(echo $2 | tr '[:lower:]' '[:upper:]')
TO=$(echo $3 | tr '[:lower:]' '[:upper:]')

value=$(curl $(echo "https://api.frankfurter.app/latest?amount=$AMOUNT&from=$FROM&to=$TO" --silent) | 
	jq | 
	grep $TO | 
	awk '{print $2}'
)

if [[ $value == "" ]] ; then
	echo "Something went wrong: check the arguments."
else
	echo "$AMOUNT $FROM is $value $TO."
fi

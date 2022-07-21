#!/usr/bin/mksh
AMOUNT=$1
FROM=$(echo $2 | tr '[:lower:]' '[:upper:]')
TO=$(echo $3 | tr '[:lower:]' '[:upper:]')

if [[ $FROM == "EUR" || $TO == "EUR" ]] ; then
	if [[ $TO == "EUR" ]] ; then
		EXR=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$FROM.EUR.SP00.A?startPeriod=$(date +%Y-%m-%d) --silent |
			grep ObsValue | cut -d "\"" -f2)

			CONVERSION=$(awk "BEGIN {print($AMOUNT/$EXR)}")

			echo $AMOUNT $FROM is $CONVERSION $TO
	elif [[ $FROM == "EUR" ]] ; then
		EXR=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$TO.EUR.SP00.A?startPeriod=$(date +%Y-%m-%d) --silent |
			grep ObsValue | cut -d "\"" -f2)

			CONVERSION=$(awk "BEGIN {print($AMOUNT*$EXR)}")

			echo $AMOUNT $FROM is $CONVERSION $TO
	fi
	else
		EXR_FROM=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$FROM.EUR.SP00.A?startPeriod=$(date +%Y-%m-%d) --silent |
			grep ObsValue | cut -d "\"" -f2)

		EXR_TO=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$TO.EUR.SP00.A?startPeriod=$(date +%Y-%m-%d) --silent |
			grep ObsValue | cut -d "\"" -f2)

		CONVERSION=$(awk "BEGIN {print($AMOUNT*$EXR_TO/$EXR_FROM)}")

		if [[ $EXR_TO == "" ]] ; then
			echo "The currency you want to convert from is not available :("
		elif [[ $EXR_FROM == "" ]] ; then
			echo "The currency you want to convert from is not available :("
		else
			echo $AMOUNT $FROM is $CONVERSION $TO
		fi
fi

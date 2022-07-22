#!/usr/bin/mksh

#------------------- Set variables -----------------------------------------#
AMOUNT=$( if [[ $1 == "" ]] ; then
	echo "1" # Feel free to change this default
else
	echo $1
fi)

FROM=$( if [[ $2 == "" ]] ; then
	echo "DKK" # Feel free to change this default
else
	echo $2 | tr '[:lower:]' '[:upper:]'
fi)

TO=$( if [[ $3 == "" ]] ; then
	echo "SEK" # Feel free to change this default
else
	echo $3 | tr '[:lower:]' '[:upper:]'
fi)

DATE=$( if [[ $4 == "" ]] ; then
	# Today's date is not always available and will cause errors when it is not.
	echo $(date --date "yesterday" +%Y-%m-%d)
else
	echo $4
fi)

echo -e "Converting $AMOUNT $FROM to $TO at $DATE... \n"

#----------------------conversion--------------------------------------------#

if [[ $FROM == "EUR" || $TO == "EUR" ]] ; then
	if [[ $TO == "EUR" ]] ; then
		EXR=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$FROM.EUR.SP00.A?startPeriod=$DATE --silent |
			grep ObsValue | awk 'NR==1' | cut -d "\"" -f2)
			if [[ $EXR == "" ]] ; then
				echo -e "Date is not available. Please select another date. \n"
			else
				CONVERSION=$(awk "BEGIN {print($AMOUNT/$EXR)}")
				echo $AMOUNT $FROM is $CONVERSION $TO
			fi
	elif [[ $FROM == "EUR" ]] ; then
		EXR=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$TO.EUR.SP00.A?startPeriod=$DATE --silent |
				grep ObsValue | awk 'NR==1' | cut -d "\"" -f2)
			if [[ $EXR == "" ]] ; then
				echo -e "Date is not available. Please select another date. \n"
			else
				CONVERSION=$(awk "BEGIN {print($AMOUNT*$EXR)}")
				echo -e "$AMOUNT $FROM is $CONVERSION $TO at $DATE \n"
			fi
	fi
	else
		EXR_FROM=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$FROM.EUR.SP00.A?startPeriod=$DATE --silent |
			grep ObsValue | awk 'NR==1' | cut -d "\"" -f2)

		EXR_TO=$(curl \\\
			https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$TO.EUR.SP00.A?startPeriod=$DATE --silent |
			grep ObsValue | awk 'NR==1' | cut -d "\"" -f2)
		if [[ $EXR_TO == "" ]] ; then
			echo -e "The currency you want to convert to or the date is not available :( \n"
		elif [[ $EXR_FROM == "" ]] ; then
			echo -e "The currency you want from convert to or the date is not available :( \n"
		else
			CONVERSION=$(awk "BEGIN {print($AMOUNT*$EXR_TO/$EXR_FROM)}")
			echo -e "$AMOUNT $FROM is $CONVERSION $TO at $DATE \n"
		fi
fi

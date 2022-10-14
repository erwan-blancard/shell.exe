#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Too fiew arguments. Exiting..."
	exit 1
elif [ $# -gt 2 ]; then
	echo "Too much arguments. Exiting..."
	exit 1
fi

cd /home/erwan/shell.exe/Alcasar_login

#remove from previous session
rm index.html
rm index.html.1

WGETOUT=$(wget --no-verbose --no-http-keep-alive https://alcasar.laplateforme.io:3991 2>&1)	#get index.html and get output
echo "WGETOUT: ${WGETOUT}"
URL=""

#parse URL from output
indexU=1
charU=$(echo $WGETOUT | head -c $(expr 24 + $indexU) | tail -c 1)

#check if charU is already empty
if [[ $charU == [[:space:]] ]]; then
	echo "Error, URL might be wrong. Exiting..."
	exit 1
fi

while [ 0 ]
do
	charU=$(echo $WGETOUT | head -c $(expr 24 + $indexU) | tail -c 1)

	if [[ $charU == [[:space:]] ]]; then
		break
	fi
	URL=${URL}${charU}
	indexU=$(expr $indexU + 1)
done

echo "URL: ${URL}"

CHALLENGE=""
USERURL=""

#CASE SENSITIVE
CHALLENGEFIELD=$(sed -n '50p' index.html)	#challenge
USERURLFIELD=$(sed -n '51p' index.html)		#userurl (should always be http:alcasar.laplateforme.io:3991)

#echo $USERURLFIELD
#echo $CHALLENGEFIELD

#iterate over CHALLENGE field
for i in {1..32}	#fixed 32 character value
do
	c=$(echo $CHALLENGEFIELD | head -c $(expr 45 + $i) | tail -c 1)

	if [ ! $c == \" ]; then
		CHALLENGE=${CHALLENGE}${c}
	else
		echo "Error, challenge field might be empty. You may already be connected or the script is unable to read \"index.html\". Exiting..."
		exit 1
	fi
done

#iterate over USERURL field
index=1
char=$(echo $USERURLFIELD | head -c $(expr 43 + $index) | tail -c 1)

if [ $char == \" ]; then
	echo "Error, userurl might be empty. Exiting..."
	exit 1
fi

while [ 0 ]
do
	char=$(echo $USERURLFIELD | head -c $(expr 43 + $index) | tail -c 1)

	if [ $char == \" ]; then
		break
	fi
	USERURL=${USERURL}${char}
	index=$(expr $index + 1)
done

echo -e "\nChallenge key is: ${CHALLENGE}"
echo "User url is: ${USERURL}"

#send POST request
echo -e "\nAttempting to send POST request...\n"

URL="${URL//notyet/"success"}"		#replace "notyet" field by "success" in url

wget --post-data="challenge=${CHALLENGE}&userurl=${USERURL}&username=${1}&password=${2}" -O index.html.1 $URL

#curl -d "challenge=${CHALLENGE}&userurl=${USERURL}&username=${1}&password=${2}" -X POST $URL

#!/bin/bash
THRESHOLD="2.0"
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
CREDENTIALS_STORE=${SCRIPT_PATH}/credentials/
STORAGE=${SCRIPT_PATH}/storage/
SLACK_TOKEN=$(cat ${CREDENTIALS_STORE}/slack_token)
DATE_TIME=$(date)
DATE_FORMATTED=$(date +'%F')

SPEED_MBS=$(wget --output-document=/dev/null http://ipv4.download.thinkbroadband.com/10MB.zip 2>&1 | \
grep '\([0-9.]\+ [KM]B/s\)' | \
sed -e 's|^.*(\([0-9.]\+ [KM]B/s\)).*$|\1|')

SPEED=$(echo ${SPEED_MBS} | grep -P -o "[0-9]+\.[0-9][0-9]")

touch ${STORAGE}/internet_speed_problem.tmp
PROBLEM_DETECTED=$(cat ${STORAGE}/internet_speed_problem.tmp)

if [ $(echo $SPEED '<' $THRESHOLD | bc -l) == 1 ]
then
	if [ $PROBLEM_DETECTED == "0" ]
	then
		curl -X POST -H 'Content-type: application/json' \
		--data "{\"text\":\"Internet speed below ${THRESHOLD}MB/s: *${SPEED_MBS}*\", \"username\": \"Skeeter\", \"icon_emoji\": \":male_zombie:\"}" \
		${SLACK_TOKEN}
	fi
	
	echo "1" > ${STORAGE}/internet_speed_problem.tmp
else
	if [ $PROBLEM_DETECTED -eq 1 ]
	then
		curl -X POST -H 'Content-type: application/json' \
		--data "{\"text\":\"Internet speed ok: *${SPEED_MBS}*\", \"username\": \"Skeeter\", \"icon_emoji\": \":male_zombie:\"}" \
		${SLACK_TOKEN}
	fi
	echo "0" > ${STORAGE}/internet_speed_problem.tmp
fi

echo "\"${DATE_TIME}\", ${SPEED}" >> "${STORAGE}/internet_speed-${DATE_FORMATTED}.csv"
echo "\"${DATE_TIME}\", ${SPEED}" >> "${STORAGE}/internet_speed.csv"

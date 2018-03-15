#!/bin/bash

LOCATION="Home"
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
STORAGE="${SCRIPT_PATH}/storage"

IP_STORE="${STORAGE}/${LOCATION}-ip.txt"

mkdir -p ${STORAGE}
touch ${IP_STORE}
touch ${SCRIPT_PATH}/slack_token

SLACK_TOKEN=$(cat ${SCRIPT_PATH}/slack_token)
IP=$(curl -s http://ipecho.net/plain)
LAST_KNOWN_IP=$(cat ${IP_STORE})

if [ "${IP}" != "${LAST_KNOWN_IP}" ] 
then
	echo "IP has changed"
	echo "${IP}" > ${IP_STORE}
	curl -X POST -H 'Content-type: application/json' \
		--data "{\"text\":\"*IP Change* - ${IP} *(${LOCATION})*\", \"username\": \"Skeeter\", \"icon_emoji\": \":male_zombie:\"}" \
		${SLACK_TOKEN}
else
	echo "IP has not changed"
fi


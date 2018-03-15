#!/bin/bash
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
CREDENTIALS_STORE=${SCRIPT_PATH}/credentials/
PLEX_TOKEN=$(cat ${CREDENTIALS_STORE}/plex_token)
SLACK_TOKEN=$(cat ${CREDENTIALS_STORE}/slack_token)
PLEX_ADDRESS="127.0.0.1:32400"

echo starting TV Section Scan
curl "http://${PLEX_ADDRESS}/library/sections/2/refresh?force=0&X-Plex-Token=${PLEX_TOKEN}"
echo starting Movie Section Scan
curl "http://${PLEX_ADDRESS}/library/sections/1/refresh?force=0&X-Plex-Token=${PLEX_TOKEN}"
echo starting Music Section Scan
curl "http://${PLEX_ADDRESS}/library/sections/3/refresh?force=0&X-Plex-Token=${PLEX_TOKEN}"

curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"Scanning sections for new PLEX media :popcorn:\", \"username\": \"Skeeter\", \"icon_emoji\": \":male_zombie:\"}" \
${SLACK_TOKEN}


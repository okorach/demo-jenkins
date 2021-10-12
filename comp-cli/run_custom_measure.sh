#!/bin/bash

# grep -E "^ *sonar.projectKey" sonar-project.properties | tail -n 1 | cut -d '=' -f 2 | cut -d ' ' -f 1 >${ARTIFACT_DIR}/projectKey.txt
# curl -X POST "${SONAR_HOST_URL}/api/custom_measures/create?projectKey=$(cat ${ARTIFACT_DIR}/projectKey.txt)&metricKey=pylint-rating&value=$(cat ${ARTIFACT_DIR}/pylint-rating.txt)" --header "login:${SONAR_TOKEN}"
curl -X POST -u ${SONAR_TOKEN}: "${SONAR_HOST_URL}/api/custom_measures/update?id=$1&metricKey=pylint-rating&value=$(cat ${ARTIFACT_DIR}/pylint-rating.txt)"

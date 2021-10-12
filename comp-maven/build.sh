#!/bin/bash

# Load common environment

mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install org.jacoco:jacoco-maven-plugin:report \
   -Dmaven.test.failure.ignore=true \
   sonar:sonar \
   -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_TOKEN \
   -Dsonar.exclusions=pom.xml \
   $*

exit $?

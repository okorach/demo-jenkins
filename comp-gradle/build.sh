#!/bin/bash

gradlew jacocoTestReport sonarqube $*

exit $?

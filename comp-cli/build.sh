#!/bin/bash
echo "Running: \
    Coverage tests
"
./run_tests.sh

echo "Running: \
    3rd part linters
"
./run_linters.sh

echo "Running: \
    sonar-scanner $* 
"
sonar-scanner $*

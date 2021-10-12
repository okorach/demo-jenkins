#!/bin/bash

# This script runs pylint, bandit and flake8 to generate 3rd party linters issues

buildDir="build"

pylintReport="$buildDir/pylint-report.out"
banditReport="$buildDir/bandit-report.json"
flake8Report="$buildDir/flake8-report.out"

[ ! -d $buildDir ] && mkdir $buildDir

echo "Running pylint"
rm -f $pylintReport
pylint src test --disable=C0114,C0116 -r n --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" > $pylintReport

echo "Running flake8"
rm -f $flake8Report
flake8 --ignore=W503,E128,C901,W504,E302,E265,E741,W291,W293,W391 --max-line-length=150 . > $flake8Report

echo "Running bandit"
rm -f $banditReport
bandit -f json --skip B311,B303,B101 -r . -x .vscode,./testpytest,./testunittest > $banditReport

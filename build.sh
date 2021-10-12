#!/bin/bash

cd comp-cli; ./build.sh $*; cd -

cd comp-maven; ./build.sh $*; cd -

cd comp-dotnet; ./build.sh $*; cd -

cd comp-gradle; ./build.sh $*; cd -
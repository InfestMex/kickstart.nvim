#!/bin/bash

work_dir="/home/viaguila/dev/current/git/xstore/"

cd $work_dir
./gradlew xstore-shell-app:build
./gradlew xstore-sco:build
cp xstore-shell-app/build/libs/xstoreshellapp.war xst-electron/
# ln -sf xstore-shell-app/build/libs/xstoreshellapp.war xst-electron/

ant -f xst-electron/build.xml build-xst-electron-app run-dev


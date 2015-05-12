#!/bin/bash

# Solano CI pre_setup hook

# Only trigger the android SDK download if it is not already installed
if ! test -d $ANDROID_HOME; then
  (cd ~ && curl http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz | tar zxv)

  # Set the minimal list of packages required
  PACKAGES="build-tools-21.1.2,android-16,android-19,android-21,extra-google-m2repository"
  PACKAGES="$PACKAGES,extra-android-m2repository,extra-google-google_play_services"

  expect -c "
  set timeout -1 ;
  spawn $ANDROID_HOME/tools/android update sdk --no-ui --all --filter $PACKAGES;
  expect {
    \"Do you accept the license\" { exp_send \"y\r\" ; exp_continue }
    eof
  }
  "
fi

# Ensure gradle is installed
./gradlew clean

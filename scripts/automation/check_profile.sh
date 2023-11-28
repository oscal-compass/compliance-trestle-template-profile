#!/bin/bash

source config.env

RESULT=$(ls profiles)

if [[ "$RESULT" == *"$PROFILE"* ]]; then
  echo "profile exists, exit 1";
  exit 1;
else
  echo "profile does not exist, exit 0"
  exit 0;
fi

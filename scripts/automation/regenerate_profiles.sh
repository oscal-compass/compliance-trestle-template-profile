#!/bin/bash

source config.env

echo "Regenerating ${PROFILE}" 
trestle author profile-generate --name $PROFILE --output md_profiles/$PROFILE

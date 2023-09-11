#!/bin/bash

source config.env

version_tag=$1
if [ "$1" != "" ]; then 
	echo "Assembling ${PROFILE} with version ${version_tag}"
	trestle author profile-assemble --markdown md_profiles/$PROFILE --output $PROFILE --version $version_tag 
else
	echo "Assembling ${PROFILE}"
	trestle author profile-assemble --markdown md_profiles/$PROFILE --output $PROFILE
fi

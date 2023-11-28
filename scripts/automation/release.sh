#!/bin/bash

source config.env

COUNT_PROFILES=$(ls -l profiles | grep ^- | wc -l)
COUNT_PROFILE_MD=$(ls -l md_profiles | grep ^- | wc -l)
if [ "$COUNT_PROFILES" == "0" ] || [ "$COUNT_PROFILE_MD" == "0" ]
then
    echo "no profile or markdown present -> nothing to do"
else
    version_tag=$(semantic-release print-version)
	echo "Bumping version of profiles to ${version_tag}" 
	export VERSION_TAG="$version_tag"
	echo "VERSION_TAG=${VERSION_TAG}" >> $GITHUB_ENV
	# There is no md but json has at least one control
	COUNT=$(ls -l md_profiles | grep ^- | wc -l)
	if [ $COUNT -lt 1 ]
	then
		./scripts/automation/regenerate_profiles.sh 
	fi
	./scripts/automation/assemble_profiles.sh $version_tag
	git config --global user.email "$EMAIL"
	git config --global user.name "$NAME" 
	semantic-release publish
fi

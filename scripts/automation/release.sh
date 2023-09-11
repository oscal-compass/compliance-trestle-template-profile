#!/bin/bash

source config.env

version_tag=$(semantic-release print-version)
echo "Bumping version of profiles to ${version_tag}" 
export VERSION_TAG="$version_tag"
echo "VERSION_TAG=${VERSION_TAG}" >> $GITHUB_ENV

COUNT=$(ls -l md_profiles | grep ^- | wc -l)
if [ $COUNT -lt 1 ]
then
	./scripts/automation/regenerate_profiles.sh $version_tag
fi

./scripts/automation/assemble_profiles.sh $version_tag
git config --global user.email "$EMAIL"
git config --global user.name "$ENAME" 
semantic-release publish

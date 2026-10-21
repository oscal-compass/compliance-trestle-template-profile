#!/bin/bash
set -eo pipefail

source config.env

COUNT_PROFILES=$(ls -1 profiles | wc -l)
COUNT_PROFILE_MD=$(ls -1 md_profiles | wc -l)
if [ "$COUNT_PROFILES" == "0" ] || [ "$COUNT_PROFILE_MD" == "0" ]
then
    echo "no profile or markdown present -> nothing to do"
else
	next_version=$(semantic-release version --print 2>/dev/null || true)
	last_version=$(semantic-release version --print-last-released 2>/dev/null || true)
	# Match v7: empty VERSION_TAG when nothing to release.
	# Untagged repos: PSR prints 0.0.0 with no bump commits — skip that stamp.
	if [ "$next_version" = "$last_version" ] || { [ -z "$last_version" ] && [ "$next_version" = "0.0.0" ]; }; then
		version_tag=""
	else
		version_tag="$next_version"
	fi
	echo "Bumping version of profiles to ${version_tag}" 
	export VERSION_TAG="$version_tag"
	echo "VERSION_TAG=${VERSION_TAG}" >> $GITHUB_ENV
	# There is no md but json has at least one control
	COUNT=$(ls -1 md_profiles | wc -l)
	if [ $COUNT -lt 1 ]
	then
		./scripts/automation/regenerate_profiles.sh 
	fi
	./scripts/automation/assemble_profiles.sh $version_tag
	git config --global user.email "$EMAIL"
	git config --global user.name "$NAME"
	# --no-push/--no-vcs-release: push.sh commits profile updates and moves the tag.
	if [ -n "$version_tag" ]; then
		semantic-release version --no-push --no-vcs-release
	fi
fi

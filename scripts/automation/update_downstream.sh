#!/bin/bash

source config.env

export COMMIT_TITLE="chore: Profiles automatic update."
export COMMIT_BODY="Sync profiles with $PROFILE repo"
git config --global user.email "$EMAIL"
git config --global user.name "$ENAME"
cd "$REPO_COMPONENT_DEFINITION"
git checkout -b "profiles_autoupdate_$GITHUB_RUN_ID"
cp -r ../profiles .
if [ -z "$(git status --porcelain)" ]; then 
  echo "Nothing to commit"
else
  git add profiles
  if [ -z "$(git status --untracked-files=no --porcelain)" ]; then 
     echo "Nothing to commit"
  else
     git commit --message "$COMMIT_TITLE"
     remote=$URL_COMPONENT_DEFINITION
     git push -u "$remote" "profiles_autoupdate_$GITHUB_RUN_ID"
     echo $COMMIT_BODY
     gh pr create -t "$COMMIT_TITLE" -b "$COMMIT_BODY" -B "develop" -H "profiles_autoupdate_$GITHUB_RUN_ID" 
  fi
fi

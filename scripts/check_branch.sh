#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Since we are building on master we have to define this
SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

echo "********** Starting build  ********** "
echo "********** Target branch: $TARGET_BRANCH ********** "


# Configuring git
GH_USER_EMAIL='t.allard@sheffield.ac.uk'

git config --global user.email "$GH_USER_EMAIL"
git config --global user.name "$GH_USER"


# GitHub confing: saving this for later
ORIGIN_URL=`git config --get remote.origin.url`
REPO_URL=${ORIGIN_URL/\/\/github.com/\/\/$GH_TOKEN@github.com}

echo "$ORIGIN_URL"


# This script will check if this is a PR or commit to the master branch
# if so it will the test, build, and merge to the gh-pages branch
# if this is onto the gh-pages branch it will build and deploy

if [ "$TRAVIS_BRANCH" = $SOURCE_BRANCH ]; then
    echo "You are working on the master branch"
    # Run script for master branch
    bash ./master_run.sh
else
   echo "You are running on $TRAVIS_BRANCH"
fi

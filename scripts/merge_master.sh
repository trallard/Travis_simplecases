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


# This script only builds when commits are made to the master branch
# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != $SOURCE_BRANCH ]; then
    echo "This is not the $SOURCE_BRANCH branch. No build will be performed"
    exit 0
fi


# Identifying the commit
SHA=`git rev-parse --verify HEAD`

# Function used to pull all the branches
function create_branches()
{
    # Keep track of where Travis put us.
    # We are on a detached head, and we need to be able to go back to it.
    local build_head=$(git rev-parse HEAD)

    # Fetch all the remote branches. Travis clones with `--depth`, which
    # implies `--single-branch`, so we need to overwrite remote.origin.fetch to
    # do that.
    git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
    git fetch
    # optionally, we can also fetch the tags
    git fetch --tags

    # create the tacking branches
    for branch in $(git branch -r|grep -v HEAD) ; do
        git checkout -qf ${branch#origin/}
    done

    # finally, go back to where we were at the beginning
    git checkout ${build_head}
}


# Run the create branches function
create_branches

# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
echo " ********** Creating new $TARGET_BRANCH branch ********** "

# Merging the source into the target branch
echo "**********  Merging $SOURCE_BRANCH into $TARGET_BRANCH SHA:${SHA} ********** "
git merge $SOURCE_BRANCH


# Push
git push --quiet $REPO_URL $TARGET_BRANCH
echo "********** Pushing to the repository **********"

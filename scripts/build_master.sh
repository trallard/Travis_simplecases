#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Since we are building on master we have to define this
SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

echo "********** Starting build  ********** "
echo "********** Target branch: $TARGET_BRANCH ********** "


# This script only builds when commits are made to the master branch
# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != $SOURCE_BRANCH ]; then
    echo "Building on a branch that is not $SOURCE_BRANCH"
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
echo " ********** Creating new gh-pages branch ********** "

# Merging the source into the target branch
echo "Merging changes"
git merge $SOURCE_BRANCH


# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A .
git commit -m "**********  Merging $SOURCE_BRANCH into $TARGET_BRANCH ${SHA} ********** "
git push --quiet $REPO_URL $TARGET_BRANCH

#!/bin/bash
set -e # Exit with nonzero exit code if anything fails
echo "********** Starting build  ********** "
echo "********** Target branch: $TARGET_BRANCH ********** "

# This script only builds when commits are made to the master branch
# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Building on master"
    echo "$TRAVIS_BRANCH"
    exit 0
fi


# Clone the existing gh-pages for this repo into out/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
git clone $REPO out
cd out
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
echo " ********** Creating new gh-pages branch ********** "
cd ..

# Clean out existing contents
echo "********** Removing old static content ********** "
rm -rf out/**/* || exit 0

# Run our compile script
# doCompile

# Now let's go have some fun with the cloned repo
cd out
git config user.name "$GH_USER_NAME"
git config user.email "$GH_USER_EMAIL"

# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if git diff --quiet; then
    echo "**********  No changes to the output on this push; exiting. ********** "
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A .
git commit -m "**********  Deploy to GitHub Pages: from current commit ${SHA} ********** "
git push --quiet $REPO_URL $TARGET_BRANCH

#! /bin/bash
set -e # Exit with nonzero exit code if anything fails

# Since we are building on master  and deploying in gh-pages:
SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

echo "********** Starting build  ********** "
echo "********** Target branch: $TARGET_BRANCH ********** "

# This script only builds when commits are made to the gh-pages branch
# Pull requests and commits to other branches shouldn't try to deploy, just build to verify
if [ "$TRAVIS_PULL_REQUEST" != "false" -o "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]; then
    echo "Skipping deploy; just doing a build."
    exit 0
fi

# Configuring git
GH_USER_EMAIL='t.allard@sheffield.ac.uk'

git config --global user.email "$GH_USER_EMAIL"
git config --global user.name "$GH_USER"

# GitHub confing: saving this for later
ORIGIN_URL=`git config --get remote.origin.url`
REPO_URL=${ORIGIN_URL/\/\/github.com/\/\/$GH_TOKEN@github.com}

echo "$ORIGIN_URL"

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
git config user.name "$GH_USER"
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

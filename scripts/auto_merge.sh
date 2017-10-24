#! /bin/bash
# Merge pushes to development branch to stable branch
if [ ! -n $2 ] ; then
    echo "Usage: auto_merge.sh <username> <password>"
    exit 1;
fi

GH_USER_NAME="$1"
GIT_PASS="$2"

# Since we are building on master we have to define this
SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

# Get the current branch
export PAGER=cat
CURRENT_BRANCH=$(git log -n 1 --pretty=%d HEAD | cut -d"," -f3 | cut -d" " -f2 | cut -d")" -f1)
echo "Current branch is '$CURRENT_BRANCH'"

# Create the URL to push merge to
URL=$(git remote -v | head -n1 | cut -f2 | cut -d" " -f1)
echo "Repo url is $URL"
PUSH_URL="https://$GH_USER_EMAIL:$GIT_PASS@${URL:6}"

if [ "$CURRENT_BRANCH" = "$SOURCE_BRANCH" ] ; then
    # Checkout the dev branch
    #git checkout $SOURCE_BRANCH && \
    #echo "Checking out $TARGET_BRANCH.." && \

    # Checkout the latest stable
    git fetch origin $TARGET_BRANCH:$TARGET_BRANCH && \
    git checkout $TARGET_BRANCH && \

    # Merge the dev into latest stable
    echo "Merging changes..." && \
    git merge $SOURCE_BRANCH && \

    # Push changes back to remote vcs
    echo "Pushing changes..." && \
    git push $PUSH_URL && \
    echo "Merge complete!" || \
    echo "Error Occurred. Merge failed"
else
    echo "Not on $SOURCE_BRANCH. Skipping merge"
fi

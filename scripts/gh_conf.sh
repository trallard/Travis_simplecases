SOURCE_BRANCH="master"
TARGET_BRANCH="gh-pages"

GH_USER_NAME='trallard'
GH_USER_EMAIL='t.allard@sheffield.ac.uk'


# configureing git
git config --global user.email "$GH_USER_EMAIL"
git config --global user.name "$GH_USER_EMAIL"


# GitHub confing: saving this for later
ORIGIN_URL=`git config --get remote.origin.url`
REPO_URL=${ORIGIN_URL/\/\/github.com/\/\/$GIT_TOKEN@github.com}

echo "$ORIGIN_URL"


SHA=`git rev-parse --verify HEAD`

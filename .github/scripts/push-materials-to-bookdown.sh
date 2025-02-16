#!/usr/bin/env bash
# bash boilerplate
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
function l { # Log a message to the terminal.
    echo
    echo -e "[$SCRIPT_NAME] ${1:-}"
}

# move to the bookdown repo
cd "./bookdown"
echo "Open root of bookdown repo"

# check if there's already a currently existing feature branch in the bookdown repo
echo "Check if feature branch $BRANCH already exists in bookdown"
git ls-remote --exit-code --heads origin $BRANCH >/dev/null 2>&1
EXIT_CODE=$?
echo "EXIT CODE $EXIT_CODE"

if [[ $EXIT_CODE == "0" ]]; then
  echo "Git branch '$BRANCH' exists in the remote repository"
  # fetch branches from bookdown
  git fetch
  # stash currently copied files
  git stash
  # check out existing branch from bookdown
  git checkout -f -b $BRANCH 
  # overwrite any previous file changes with current ones
  git stash pop
else
  echo "Git branch '$BRANCH' does not exist in the remote repository"
  # create a new branch in bookdown
  git checkout -b $BRANCH
fi

git add -A .
git config user.name github-actions
git config user.email github-actions@github.com
git commit -am "feat: Update weekly materials files replicated from weekly repo"
git push --set-upstream -f origin $BRANCH

echo "Updated files successfully pushed to bookdown repo"
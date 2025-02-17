#!/usr/bin/env bash
# bash boilerplate
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
function l { # Log a message to the terminal.
    echo
    echo -e "[$SCRIPT_NAME] ${1:-}"
}

# move to the root the notehub-js repo
cd "./bookdown"
echo "Open root of bookdown repo"
ls -a
# check if there's already a currently existing feature branch in notehub-js for this branch
# i.e. the altered openapi.yaml file's already been copied there at least once before
echo "Check if feature branch $BRANCH already exists in bookdown"
git ls-remote --exit-code --heads origin $BRANCH >/dev/null 2>&1
EXIT_CODE=$?
echo "EXIT CODE $EXIT_CODE"

if [[ $EXIT_CODE == "0" ]]; then
  echo "Git branch '$BRANCH' exists in the remote repository"
  # fetch branches from bookdown
  git fetch
  ls -a
  # stash currently copied files
  git stash 
  ls -a
  # check out existing branch from bookdown
  git checkout $BRANCH 
  ls -a
  # overwrite any previous file changes with current ones
  git checkout stash -- .
  ls -a
else
  echo "Git branch '$BRANCH' does not exist in the remote repository"
  # create a new branch in notehub-js 
  git checkout -b $BRANCH
fi

git add -A .
git config user.name github-actions
git config user.email github-actions@github.com
git commit -am "feat: Update weekly materials files replicated from weekly repo"
git push --set-upstream origin $BRANCH

echo "Updated files successfully pushed to bookdown repo"
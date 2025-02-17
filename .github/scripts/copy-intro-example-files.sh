#!/usr/bin/env bash
# bash boilerplate
set -euo pipefail # strict mode
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
function l { # Log a message to the terminal.
    echo
    echo -e "[$SCRIPT_NAME] ${1:-}"
}

# Files to copy from Weekly Materials 
INTRO_EXAMPLE_FILES=$(ls | grep -E '^[0-9]+-(0_Intro|0_intro|1_Examples)\.(Rmd|qmd)$')
DIRECTORIES=$(ls | grep -E '(Data|data|Images|images|Figures|figures)')
echo $INTRO_EXAMPLE_FILES
echo $DIRECTORIES

# if the file exists in Materials, copy it to Bookdown repo
#if [ -f "$INTRO_EXAMPLE_FILES" ]; then

    for file in $INTRO_EXAMPLE_FILES; do
        echo "Processing: $file"
        cp -R $file $DESTINATION_PATH/$file
    done
#fi    
echo "Intro and Example files copied to $DESTINATION_PATH"
ls ./bookdown -a


# if the directory exists in Materials, copy it to Bookdown repo
    for dir in $DIRECTORIES; do
        echo "Processing: $dir"
        mkdir -p $DESTINATION_PATH$dir
        files=$(ls $dir)
        for file in $files; do
            cp -R $dir/$file $DESTINATION_PATH$dir/$file
        done
    done


echo "Directories copied to $DESTINATION_PATH"
ls ./bookdown -a
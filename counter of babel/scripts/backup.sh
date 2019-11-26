#!/bin/bash

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
PROJECT_ROOT="$SCRIPTPATH/.."

DATE=`date +%Y-%m-%d_%H:%M:%S`
WHO=$(whoami)

# Stop executing the script if any command fails.
# See http://stackoverflow.com/a/4346420/442022 for details.
set -e
set -o pipefail

_bold_="\x1B[1m"
_yellow_="\x1B[93m"
_red_="\x1B[31m"
_green_="\x1B[92m"
_clear_="\x1B[0m"

FILENAME="$(date +%Y%m%d).sql.gzip"
REMOTE_FILENAME="/tmp/babel-$FILENAME"
LOCAL_FOLDER="$PROJECT_ROOT/tmp"
LOCAL_FILENAME="$LOCAL_FOLDER/babel-$FILENAME"

printf "\n"
printf "Starting backup ...\n"
printf "\n"

mkdir -p "$LOCAL_FOLDER"
ssh steveshaddick.com "mysqldump babel | gzip > $REMOTE_FILENAME"
rsync -avz -e ssh steveshaddick.com:$REMOTE_FILENAME "$LOCAL_FILENAME"

printf "\n"
printf "${_green_}Done!${_clear_}\n"
printf "\n"

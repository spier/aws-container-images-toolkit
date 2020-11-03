#!/usr/bin/env bash

# set -o errexit
set -o errtrace
set -o pipefail

function detect() {

tdir=$(dirname $TARGET_DIR)/$(basename $TARGET_DIR)

# iterate over all Dockerfiles and list images:
filelist=($(find . -type f -name Dockerfile\*))

for dockerfile in ${filelist[*]}; do
  images=$(grep "^FROM" $dockerfile | grep -E -o [^[:space:]]+:[^[:space:]]+) 
  for image in $images; do
    if ! echo $image | awk -F '[/:]' '{print $1}' | grep -q '\.'; then
      echo "$dockerfile $image"
    elif echo $image | grep -q docker.io ; then
      echo "$dockerfile $image"
    fi
  done
done
}


### MAIN
CURRENT_DIR=$(pwd)
TARGET_DIR=${1:-$CURRENT_DIR}

detect
#!/bin/bash

ALL=`git rev-list --all --count`
echo "HEAD revision number include all the tags and branches: $ALL"

COMMIT=`git rev-list $1 --count`
echo "Commit $1 revision number: $COMMIT"

HEAD=`git rev-list HEAD --count`
COMMIT_ALL=$((ALL-HEAD+COMMIT))
echo "Commit $1 revision number include all the tags and branches: $COMMIT_ALL"
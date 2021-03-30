#!/bin/bash

set -e


(
    cd /action
    echo "install action deps"

    [ -f yarn.lock ] && NODE_ENV=production yarn install --frozen-lockfile --prefer-offline
    [ -f package-lock.json ] && NODE_ENV=production npm install 
)

cd frontend
echo "Execute From Directory: $(pwd)"

if [ ! -d "./node_modules" ] || [ "$2" = 'true' ] ; then
    echo "install dependencies"
    [ -f yarn.lock ] && yarn install --frozen-lockfile --prefer-offline
    [ -f package-lock.json ] && npm ci
fi

NODE_PATH=node_modules GITHUB_TOKEN="${GITHUB_TOKEN:-${1:-.}}" SOURCE_ROOT=${2:-.} node /action/lib/run.js

# rm -rf node_modules # cleanup to prevent some weird permission errors later on 

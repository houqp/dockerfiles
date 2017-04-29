#!/bin/bash

set -o xtrace

echo "$CIRCLE_BRANCH"
echo "${CIRCLE_SHA1}"
echo "$CIRCLE_REPOSITORY_URL"
echo "$CIRCLE_COMPARE_URL"

echo "${CIRCLE_BUILD_URL}"
echo "${CIRCLE_PREVIOUS_BUILD_NUM}"


echo "${CI_PULL_REQUEST}"
echo "${CI_PULL_REQUESTS}"

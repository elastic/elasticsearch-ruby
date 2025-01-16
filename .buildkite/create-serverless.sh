#!/usr/bin/env bash

set -euo pipefail

if [[ -z $EC_PROJECT_PREFIX ]]; then
  echo -e "\033[31;1mERROR:\033[0m Required environment variable [EC_PROJECT_PREFIX] not set\033[0m"
  exit 1
fi

# Using BUILDKITE_JOB_ID for the name to make it unique:
export EC_PROJECT_NAME="$EC_PROJECT_PREFIX-$BUILDKITE_JOB_ID"
echo -e "--- :elasticsearch: Start serverless instance $EC_PROJECT_NAME"

qaf elastic-cloud projects create --project-type elasticsearch
deployment=$(qaf elastic-cloud projects describe $EC_PROJECT_NAME --as-json --show-credentials)

# Set ELASTICSEARCH_URL and API_KEY variables
export ES_API_SECRET_KEY=$(echo "$deployment" | jq -r '.credentials.api_key')
export ELASTICSEARCH_URL=$(echo "$deployment" | jq -r '.elasticsearch.url')
buildkite-agent meta-data set "ES_API_SECRET_KEY" $ES_API_SECRET_KEY
buildkite-agent meta-data set "ELASTICSEARCH_URL" $ELASTICSEARCH_URL
buildkite-agent meta-data set "EC_PROJECT_NAME" $EC_PROJECT_NAME

echo -e "--- :computer: Environment variables"
echo -e "ELASTICSEARCH_URL $ELASTICSEARCH_URL"

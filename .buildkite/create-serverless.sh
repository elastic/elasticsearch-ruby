#!/usr/bin/env bash

set -euo pipefail

# Using BUILDKITE_JOB_ID for the name to make it unique:
export EC_PROJECT_NAME="$EC_PROJECT_PREFIX-$BUILDKITE_JOB_ID"

# ensure serverless instance is deleted even if script errors
cleanup() {
  echo -e "--- :elasticsearch: :broom::sparkles: Tear down serverless instance $EC_PROJECT_NAME"
  qaf elastic-cloud projects delete
  rm -rf "~/.elastic/cloud.json"
}
trap cleanup EXIT

echo -e "--- :elasticsearch: Start serverless instance $EC_PROJECT_NAME"

qaf elastic-cloud projects create --project-type elasticsearch
deployment=$(qaf elastic-cloud projects describe $EC_PROJECT_NAME --as-json --show-credentials)

# Set ELASTICSEARCH_URL and API_KEY variables
export ES_API_SECRET_KEY=$(echo "$deployment" | jq -r '.credentials.api_key')
export ELASTICSEARCH_URL=$(echo "$deployment" | jq -r '.elasticsearch.url')

echo -e "--- :computer: Environment variables"
echo -e "ELASTICSEARCH_URL $ELASTICSEARCH_URL"

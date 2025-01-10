#!/usr/bin/env bash

set -euo pipefail

export EC_REGISTER_BACKEND=buildkite
export EC_ENV=qa
export EC_REGION=aws-eu-west-1
# Using BUILDKITE_JOB_ID for the name to make it unique:
export EC_PROJECT_NAME="$EC_PROJECT_PREFIX-$BUILDKITE_JOB_ID"

# fetch cloud creds used by qaf
CLOUD_ACCESS_KEY=$(vault read -field="$EC_ENV" $CLOUD_CREDENTIALS_PATH)
echo "{\"api_key\":{\"$EC_ENV\":\"$CLOUD_ACCESS_KEY\"}}" > "$(pwd)/cloud.json"

echo -e "--- Buildkite: ${BUILDKITE}"

run_qaf() {
  cmd=$1
  docker run --rm \
         -e EC_REGISTER_BACKEND \
         -e EC_ENV \
         -e EC_REGION \
         -e EC_PROJECT_NAME \
         -e VAULT_TOKEN \
         -e "BUILDKITE=${BUILDKITE}" \
         -v "$(pwd)/cloud.json:/root/.elastic/cloud.json" \
         docker.elastic.co/appex-qa/qaf:latest \
         bash -c "$cmd"
}

# ensure serverless instance is deleted even if script errors
cleanup() {
  echo -e "--- :elasticsearch: :broom::sparkles: Tear down serverless instance $EC_PROJECT_NAME"
  run_qaf 'qaf elastic-cloud projects delete'
  rm -rf "$(pwd)/cloud.json"
}
trap cleanup EXIT

echo -e "--- :elasticsearch: Start serverless instance $EC_PROJECT_NAME"

run_qaf "qaf elastic-cloud projects create --project-type elasticsearch"
deployment=$(run_qaf "qaf elastic-cloud projects describe $EC_PROJECT_NAME --as-json --show-credentials")

# Set ELASTICSEARCH_URL and API_KEY variables
export ES_API_SECRET_KEY=$(echo "$deployment" | jq -r '.credentials.api_key')
export ELASTICSEARCH_URL=$(echo "$deployment" | jq -r '.elasticsearch.url')

echo -e "--- :computer: Environment variables"
echo -e "ELASTICSEARCH_URL $ELASTICSEARCH_URL"

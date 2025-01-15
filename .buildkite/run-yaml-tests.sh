#!/usr/bin/env bash
#
# Script to run YAML runner integration tests on Buildkite
#
# Version 0.1
#
script_path=$(dirname $(realpath -s $0))

if [[ "$TEST_SUITE" == "serverless" ]]; then
  # Get Elasticsearch Serverless credentials and endpoint
  export TEST_ES_SERVER=`buildkite-agent meta-data get "ELASTICSEARCH_URL"`
  export ES_API_SECRET_KEY=`buildkite-agent meta-data get "ES_API_SECRET_KEY"`
else
  # Start Elasticsearch Stack on Docker
  source $script_path/functions/imports.sh
  echo "--- :elasticsearch: Starting Elasticsearch"
  DETACH=true bash $script_path/run-elasticsearch.sh
fi

set -euo pipefail
repo=`pwd`

export RUBY_VERSION=${RUBY_VERSION:-3.1}
export BUILDKITE=${BUILDKITE:-false}
export TRANSPORT_VERSION=${TRANSPORT_VERSION:-8}
export QUIET=${QUIET:-false}
export DEBUG=${DEBUG:-false}
export TEST_SUITE=${TEST_SUITE:-platinum}

echo "--- :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_VERSION=$RUBY_VERSION \
       --build-arg TRANSPORT_VERSION=$TRANSPORT_VERSION \
       --build-arg RUBY_SOURCE=$RUBY_SOURCE \
       .

mkdir -p elasticsearch-api/tmp

if [[ "$TEST_SUITE" == "serverless" ]]; then
  echo "--- :ruby: Running :yaml: tests"
  docker run \
         -u "$(id -u)" \
         --env "TEST_ES_SERVER=${TEST_ES_SERVER}" \
         --env "ES_API_KEY=${ES_API_SECRET_KEY}" \
         --env "BUILDKITE=${BUILDKITE}" \
         --env "TRANSPORT_VERSION=${TRANSPORT_VERSION}" \
         --env "ES_YAML_TESTS_BRANCH=${ES_YAML_TESTS_BRANCH}" \
         --env "DEBUG=${DEBUG}" \
         --env "QUIET=${QUIET}" \
         --volume $repo:/usr/src/app \
         --name elasticsearch-ruby \
         --rm \
         elastic/elasticsearch-ruby \
         bundle exec rake test:yaml
else
  echo "--- :ruby: Running stack tests"
  docker run \
         -u "$(id -u)" \
         --network="${network_name}" \
         --env "TEST_ES_SERVER=${elasticsearch_url}" \
         --env "ELASTIC_PASSWORD=${elastic_password}" \
         --env "ELASTIC_USER=elastic" \
         --env "STACK_VERSION=${STACK_VERSION}" \
         --env "BUILDKITE=${BUILDKITE}" \
         --env "TRANSPORT_VERSION=${TRANSPORT_VERSION}" \
         --env "ES_YAML_TESTS_BRANCH=${ES_YAML_TESTS_BRANCH}" \
         --env "DEBUG=${DEBUG}" \
         --env "QUIET=${QUIET}" \
         --volume $repo:/usr/src/app \
         --name elasticsearch-ruby \
         --rm \
         elastic/elasticsearch-ruby \
         bundle exec rake test:yaml
fi

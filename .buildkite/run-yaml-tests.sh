#!/usr/bin/env bash
#
# Script to run YAML runner integration tests on Buildkite
#
# Version 0.1
#
script_path=$(dirname $(realpath -s $0))
source $script_path/functions/imports.sh
set -euo pipefail
repo=`pwd`

echo "--- :elasticsearch: Starting Elasticsearch"
DETACH=true bash $script_path/run-elasticsearch.sh

export RUBY_VERSION=${RUBY_VERSION:-3.1}
export TRANSPORT_VERSION=${TRANSPORT_VERSION:-8}

echo "--- :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_VERSION=$RUBY_VERSION \
       --build-arg TRANSPORT_VERSION=$TRANSPORT_VERSION \
       --build-arg RUBY_SOURCE=$RUBY_SOURCE \
       .

mkdir -p elasticsearch-api/tmp

echo "--- :ruby: Running :yaml: tests"
docker run \
       -u "$(id -u)" \
       --network="${network_name}" \
       --env "TEST_ES_SERVER=${elasticsearch_url}" \
       --env "ELASTIC_PASSWORD=${elastic_password}" \
       --env "ELASTIC_USER=elastic" \
       --env "BUILDKITE=true" \
       --env "TRANSPORT_VERSION=${TRANSPORT_VERSION}" \
       --env "STACK_VERSION=${STACK_VERSION}" \
       --env "ES_YAML_TESTS_BRANCH=${ES_YAML_TESTS_BRANCH}" \
       --env "DEBUG=${DEBUG}" \
       --volume $repo:/usr/src/app \
       --name elasticsearch-ruby \
       --rm \
       elastic/elasticsearch-ruby \
       bundle exec rake test:yaml

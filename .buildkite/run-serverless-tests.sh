#!/usr/bin/env bash
#
# Once called Elasticsearch should be up and running
#
script_path=$(dirname $(realpath -s $0))
set -euo pipefail
repo=`pwd`

export RUBY_VERSION=${RUBY_VERSION:-3.4}
export BUILDKITE=${BUILDKITE:-false}
export TRANSPORT_VERSION=${TRANSPORT_VERSION:-8}
ELASTICSEARCH_URL=`buildkite-agent meta-data get "ELASTICSEARCH_URL"`
ES_API_SECRET_KEY=`buildkite-agent meta-data get "ES_API_SECRET_KEY"`

echo "--- :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_VERSION=$RUBY_VERSION \
       --build-arg TRANSPORT_VERSION=$TRANSPORT_VERSION \
       --build-arg RUBY_SOURCE=$RUBY_SOURCE \
       .

mkdir -p elasticsearch-api/tmp

echo "--- :ruby: Running $TEST_SUITE tests"
docker run \
       -u "$(id -u)" \
       -e "ELASTIC_USER=elastic" \
       -e "QUIET=${QUIET}" \
       -e "BUILDKITE=${BUILDKITE}" \
       -e "TRANSPORT_VERSION=${TRANSPORT_VERSION}" \
       -e "ELASTICSEARCH_URL=${ELASTICSEARCH_URL}" \
       -e "ES_API_KEY=${ES_API_SECRET_KEY}" \
       --volume $repo:/usr/src/app \
       --name elasticsearch-ruby \
       --rm \
       elastic/elasticsearch-ruby \
       bundle exec bundle exec rake test:yaml

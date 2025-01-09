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

if [[ -z $EC_PROJECT_PREFIX ]]; then
  echo -e "\033[31;1mERROR:\033[0m Required environment variable [EC_PROJECT_PREFIX] not set\033[0m"
  exit 1
fi

# Create a serverless project:
source $script_path/create-serverless.sh
# Make sure we remove projects:
trap cleanup EXIT

echo "--- :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_VERSION=$RUBY_VERSION \
       --build-arg TRANSPORT_VERSION=$TRANSPORT_VERSION \
       --build-arg RUBY_SOURCE=$RUBY_SOURCE \
       .

echo "--- :ruby: Running $TEST_SUITE tests"
docker run \
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
       bundle exec rake info

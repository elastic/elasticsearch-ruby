#!/usr/bin/env bash
#
# Once called Elasticsearch should be up and running
#
script_path=$(dirname $(realpath -s $0))
set -euo pipefail
repo=`pwd`

export RUBY_VERSION=${RUBY_VERSION:-3.1}
export TRANSPORT_VERSION=${TRANSPORT_VERSION:-8}

if [[ "$TEST_SUITE" == "serverless" ]]; then
  if [[ -z $EC_PROJECT_PREFIX ]]; then
    echo -e "\033[31;1mERROR:\033[0m Required environment variable [EC_PROJECT_PREFIX] not set\033[0m"
    exit 1
  fi

  # Create a serverless project:
  source $script_path/create-serverless.sh

  # Make sure we remove projects:
  trap cleanup EXIT
fi

echo "--- :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_VERSION=$RUBY_VERSION \
       --build-arg TRANSPORT_VERSION=$TRANSPORT_VERSION \
       --build-arg RUBY_SOURCE=$RUBY_SOURCE \
       .

mkdir -p elasticsearch-api/tmp

# TODO: Use TEST_SUITE for serverless/stack

echo "--- :ruby: Running $TEST_SUITE tests"

if [[ "$TEST_SUITE" == "serverless" ]]; then
  docker run \
         -e "ELASTIC_USER=elastic" \
         -e "BUILDKITE=true" \
         -e "QUIET=${QUIET}" \
         -e "TRANSPORT_VERSION=${TRANSPORT_VERSION}" \
         -e "ELASTICSEARCH_URL=${ELASTICSEARCH_URL}" \
         -e "API_KEY=${ES_API_SECRET_KEY}" \
         --volume $repo:/usr/src/app \
         --name elasticsearch-ruby \
         --rm \
         elastic/elasticsearch-ruby \
         bundle exec rake info
else
  docker run \
         -u "$(id -u)" \
         --network="${network_name}" \
         --env "TEST_ES_SERVER=${elasticsearch_url}" \
         --env "ELASTIC_PASSWORD=${elastic_password}" \
         --env "TEST_SUITE=${TEST_SUITE}" \
         --env "ELASTIC_USER=elastic" \
         --env "BUILDKITE=true" \
         --env "QUIET=${QUIET}" \
         --env "TRANSPORT_VERSION=${TRANSPORT_VERSION}" \
         --env "STACK_VERSION=${STACK_VERSION}" \
         --volume $repo:/usr/src/app \
         --name elasticsearch-ruby \
         --rm \
         elastic/elasticsearch-ruby \
         bundle exec rake es:download_artifacts test:platinum:integration test:rest_api
fi

#!/usr/bin/env bash
#
# Once called Elasticsearch should be up and running
#
script_path=$(dirname $(realpath -s $0))
set -euo pipefail
repo=`pwd`

export RUBY_VERSION=${RUBY_VERSION:-3.1}

echo "--- :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_VERSION=$RUBY_VERSION \
       .

mkdir -p elasticsearch-api/tmp

echo "--- :ruby: Running $TEST_SUITE tests"
docker run \
       -u "$(id -u)" \
       --network="${network_name}" \
       --env "TEST_ES_SERVER=${elasticsearch_url}" \
       --env "ELASTIC_PASSWORD=${elastic_password}" \
       --env "TEST_SUITE=${TEST_SUITE}" \
       --env "ELASTIC_USER=elastic" \
       --env "BUILDKITE=true" \
       --volume $repo:/usr/src/app \
       --name elasticsearch-ruby \
       --rm \
       elastic/elasticsearch-ruby \
       bundle exec rake elasticsearch:download_artifacts test:platinum:integration test:rest_api

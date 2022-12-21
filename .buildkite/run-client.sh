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

echo "--- :ruby: Running container"
docker run \
       -u "$(id -u)" \
       --volume $repo:/usr/src/app \
       --network=$network_name \
       --name elasticsearch-ruby \
       --env ELASTICSEARCH_HOST=$elasticsearch_url \
       --rm \
       elastic/elasticsearch-ruby \
       bundle exec rake elasticsearch:health

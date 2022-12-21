#!/usr/bin/env bash
#
# Launch one or more Elasticsearch nodes via the Docker image,
# to form a cluster suitable for running the REST API tests.
#

# Setup
script_path=$(dirname $(realpath -s $0))
source $script_path/STACK_VERSION
source $script_path/wait-for-container.sh

ES_NODE_NAME=es01

docker pull docker.elastic.co/elasticsearch/elasticsearch:$STACK_VERSION
docker network create elastic
docker run --name $ES_NODE_NAME \
       --net elastic \
       -p 9200:9200 \
       --detach=$DETACH \
       --health-cmd="curl --fail http://$ES_NODE_NAME/_cluster/health || exit 1" \
       --health-interval=2s \
       --health-retries=20 \
       --health-timeout=2s \
       -it \
       docker.elastic.co/elasticsearch/elasticsearch:$STACK_VERSION
set +x
if wait_for_container "$ES_NODE_NAME" elastic; then
  echo -e "\033[32;1mSUCCESS:\033[0m Running on: $node_url\033[0m"
fi

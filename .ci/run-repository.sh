#!/usr/bin/env bash
#
# Called by entry point `run-test` use this script to add your repository specific test commands
#
# Once called Elasticsearch is up and running and the following parameters are available to this script

# ELASTICSEARCH_VERSION -- version e.g Major.Minor.Patch(-Prelease)
# ELASTICSEARCH_CONTAINER -- the docker moniker as a reference to know which docker image distribution is used
# ELASTICSEARCH_URL -- The url at which elasticsearch is reachable
# NETWORK_NAME -- The docker network name
# NODE_NAME -- The docker container name also used as Elasticsearch node name

# When run in CI the test-matrix is used to define additional variables

# TEST_SUITE -- either `oss` or `xpack`, defaults to `oss` in `run-tests`
#
# As well as any repos specific variables

echo -e "\033[34;1mINFO:\033[0m URL: ${ELASTICSEARCH_URL}\033[0m"
echo -e "\033[34;1mINFO:\033[0m VERSION: ${ELASTICSEARCH_VERSION}\033[0m"
echo -e "\033[34;1mINFO:\033[0m CONTAINER: ${ELASTICSEARCH_CONTAINER}\033[0m"
echo -e "\033[34;1mINFO:\033[0m TEST_SUITE: ${TEST_SUITE}\033[0m"
echo -e "\033[34;1mINFO:\033[0m RUNSCRIPTS: ${RUNSCRIPTS}\033[0m"

RUNSCRIPTS=${RUNSCRIPTS-}
ELASTIC_PASSWORD=${ELASTIC_PASSWORD-changeme}
SCRIPT_PATH=$(dirname $(realpath -s $0))

cert_validation_flags="--insecure"
url="http://localhost"
if [[ "$TEST_SUITE" == "xpack" ]]; then
  url="https://elastic:$ELASTIC_PASSWORD@localhost"
fi

set +x

echo -e "\033[34;1mINFO:\033[0m pinging Elasticsearch ..\033[0m"
curl $cert_validation_flags --fail $url:9200/_cluster/health?pretty
echo -e "\033[32;1mSUCCESS:\033[0m successfully started the ${ELASTICSEARCH_VERSION} stack.\033[0m"

# Ruby client setup:

export RUBY_TEST_VERSION=${RUBY_TEST_VERSION:-2.7.0}
export ELASTICSEARCH_VERSION=${ELASTICSEARCH_VERSION:-8.0.0-SNAPSHOT}
export SINGLE_TEST=${SINGLE_TEST}

set +x
export VAULT_TOKEN=$(vault write -field=token auth/approle/login role_id="$VAULT_ROLE_ID" secret_id="$VAULT_SECRET_ID")
unset VAULT_ROLE_ID VAULT_SECRET_ID VAULT_TOKEN
set -x

echo -e "\033[1m>>>>> Build [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"
# create client image
docker build \
       --file .ci/Dockerfile \
       --tag elastic/elasticsearch-ruby \
       --build-arg RUBY_TEST_VERSION=${RUBY_TEST_VERSION} \
       .

echo -e "\033[1m>>>>> Run [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"

sh .ci/docker/run-${TEST_SUITE}

#!/usr/bin/env bash
# parameters are available to this script

# common build entry script for all elasticsearch clients

# ./.ci/make.sh bump VERSION
# ./.ci/make.sh build[TARGET_DIR]
script_path=$(dirname "$(realpath -s "$0")")
repo=$(realpath "$script_path/../")

# shellcheck disable=SC1090
CMD=$1
VERSION=$2
set -euo pipefail

TARGET_DIR=${TARGET_DIR-.ci/output}
OUTPUT_DIR="$repo/${TARGET_DIR}"
RUBY_TEST_VERSION=${RUBY_TEST_VERSION-2.7}
GITHUB_TOKEN=${GITHUB_TOKEN-nil}
RUBYGEMS_API=${RUBYGEMS_API-nil}
GIT_NAME=${GIT_NAME-elastic}
GIT_EMAIL=${GIT_EMAIL-'clients-team@elastic.co'}

case $CMD in
    assemble)
        TASK=assemble[$VERSION,$TARGET_DIR]
        ;;
    *)
        echo -e "\nUsage:"
        echo -e "\t Build snapshot gems:"
        echo -e "\t $0 assemble_snapshot [version_qualifier]\n"
        echo -e "\t Build release gems:"
        echo -e "\t $0 assemble [version_qualifier]\n"
        exit 1
esac

echo -e "\033[34;1mINFO:\033[0m OUTPUT_DIR ${OUTPUT_DIR}\033[0m"
echo -e "\033[34;1mINFO:\033[0m RUBY_TEST_VERSION ${RUBY_TEST_VERSION}\033[0m"

echo -e "\033[1m>>>>> Build [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"

docker build --file .ci/Dockerfile --tag elastic/elasticsearch-ruby .

echo -e "\033[1m>>>>> Run [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"

mkdir -p "$OUTPUT_DIR"

docker run \
       --env "RUBY_TEST_VERSION=${RUBY_TEST_VERSION}" \
       --env "GITHUB_TOKEN" \
       --env "RUBYGEMS_API_KEY" \
       --env "GIT_EMAIL" \
       --env "GIT_NAME" \
       --name test-runner \
       --volume $repo:/usr/src/app \
       --volume "${OUTPUT_DIR}:/${TARGET_DIR}" \
       --rm \
       elastic/elasticsearch-ruby \
       bundle exec rake unified_release:"$TASK"

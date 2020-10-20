#!/usr/bin/env bash
# parameters are available to this script

# common build entry script for all elasticsearch clients

# ./.ci/make.sh bump VERSION
# ./.ci/make.sh release TARGET_DIR
script_path=$(dirname "$(realpath -s "$0")")
repo=$(realpath "$script_path/../")

# shellcheck disable=SC1090
CMD=$1
VERSION=$2
set -euo pipefail

TARGET_DIR=".ci/output"
OUTPUT_DIR="$repo/${TARGET_DIR}"
RUBY_TEST_VERSION=${RUBY_TEST_VERSION-2.7}

case $CMD in
    bump)
        TASK=bump["$VERSION"]
        ;;
    build)
        TASK=build["$TARGET_DIR"]
        ;;
    *)
        echo -e "\nUsage:\n\t $0 {bump[VERSION]|build[VERSION,TARGET_DIR]}\n"
        exit 1
esac

echo -e "\033[34;1mINFO:\033[0m OUTPUT_DIR ${OUTPUT_DIR}\033[0m"
echo -e "\033[34;1mINFO:\033[0m RUBY_TEST_VERSION ${RUBY_TEST_VERSION}\033[0m"

echo -e "\033[1m>>>>> Build [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"

docker build --file .ci/Dockerfile --tag elastic/elasticsearch-ruby .

echo -e "\033[1m>>>>> Run [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"

mkdir -p "$OUTPUT_DIR"

docker run \
  --env "RUBY_TEST_VERSION" \
  --name test-runner \
  --volume "${OUTPUT_DIR}:/${TARGET_DIR}" \
  --rm \
  elastic/elasticsearch-ruby \
  bundle exec rake "$TASK"

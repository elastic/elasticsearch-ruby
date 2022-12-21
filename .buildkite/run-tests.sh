#!/usr/bin/env bash
#
# Script to run Elasticsearch container and Elasticsearch client integration tests on Buildkite
#
# Version 0.1
#
script_path=$(dirname $(realpath -s $0))
set -euo pipefail

# Run Elasticsearch Docker Container
DETACH=true bash $script_path/run-elasticsearch.sh

# Run Client Docker Container
bash $script_path/run-client.sh

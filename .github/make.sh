#!/usr/bin/env bash
# ------------------------------------------------------- #
#
# Build entry script for elasticsearch-ruby
#
# Must be called: ./.github/make.sh <target> <params>
#
# Version: 1.1.0
#
# Targets:
# ---------------------------
# assemble   <VERSION> : build client artefacts with version
# bump       <VERSION> : bump client internals to version
# bumpmatrix <VERSION> : bump stack version in test matrix to version
# codegen              : generate endpoints
# docsgen    <VERSION> : generate documentation
# examplegen           : generate the doc examples
# clean                : clean workspace
#
# ------------------------------------------------------- #

# ------------------------------------------------------- #
# Bootstrap
# ------------------------------------------------------- #
script_path=$(dirname "$(realpath -s "$0")")
repo=$(realpath "$script_path/../")

# shellcheck disable=SC1090
CMD=$1
TASK=$1
TASK_ARGS=()
VERSION=$2
STACK_VERSION=$VERSION
set -euo pipefail

product="elastic/elasticsearch-ruby"
RUBY_VERSION=${RUBY_VERSION-3.1}
WORKFLOW=${WORKFLOW-staging}

echo -e "\033[34;1mINFO:\033[0m PRODUCT ${product}\033[0m"
echo -e "\033[34;1mINFO:\033[0m VERSION ${STACK_VERSION}\033[0m"
echo -e "\033[34;1mINFO:\033[0m RUBY_VERSION ${RUBY_VERSION}\033[0m"

case $CMD in
    clean)
        echo -e "\033[36;1mTARGET: clean workspace $output_folder\033[0m"
        rm -rf "/build"
        echo -e "\033[32;1mdone.\033[0m"
        exit 0
        ;;
    assemble)
        echo -e "\033[36;1mTARGET: assemble\033[0m"
        TASK=build_gems
        ;;
    codegen)
        TASK=codegen
        TASK_ARGS=()
        ;;
    docsgen)
        if [ -v $VERSION ]; then
            echo -e "\033[31;1mTARGET: docsgen -> missing version parameter\033[0m"
            exit 1
        fi
        echo -e "\033[36;1mTARGET: generate docs for $VERSION\033[0m"
        TASK=codegen
        ;;
    examplesgen)
        echo -e "\033[36;1mTARGET: generate docs examples\033[0m"
        TASK='docs:generate'
        TASK_ARGS=()
        ;;
    bump)
        if [ -v $VERSION ]; then
            echo -e "\033[31;1mTARGET: bump -> missing version parameter\033[0m"
            exit 1
        fi
        echo -e "\033[36;1mTARGET: bump to version $VERSION\033[0m"
        TASK=bump
        # VERSION is BRANCH here for now
        TASK_ARGS=("$VERSION")
        ;;
    bumpmatrix)
      if [ -v $VERSION ]; then
        echo -e "\033[31;1mTARGET: bumpmatrix -> missing version parameter\033[0m"
        exit 1
      fi
      echo -e "\033[36;1mTARGET: bump stack in test matrix to version $VERSION\033[0m"
      TASK=bumpmatrix
      TASK_ARGS=("$VERSION")
      ;;
    *)
        echo -e "\nUsage:"
        echo -e "\t Generate API code:"
        echo -e "\t $0 codegen\n"
        echo -e "\t Build gems:"
        echo -e "\t $0 assemble [version_qualifier]\n"
        echo -e "\t Bump version:"
        echo -e "\t $0 bump [version_qualifier]\n"
        echo -e "\t Bump stack version in test matrices:"
        echo -e "\t $0 bumpmatrix [version_qualifier]\n"
        echo -e "\t Clean workspace:"
        echo -e "\t $0 clean\n"
        echo -e "\t Generate example documentation:"
        echo -e "\t $0 examplesgen\n"
        exit 1
esac

echo -e "\033[1m>>>>> Build [elastic/elasticsearch-ruby container] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>\033[0m"

# ------------------------------------------------------- #
# Build Container
# ------------------------------------------------------- #

echo -e "\033[34;1mINFO: building $product container\033[0m"
docker build --no-cache --build-arg BUILDER_UID="$(id -u)" --file .buildkite/Dockerfile --tag ${product} .

# ------------------------------------------------------- #
# Run the Container
# ------------------------------------------------------- #

echo -e "\033[34;1mINFO: running $product container\033[0m"

# Convert ARGS to comma separated string for Rake:
args_string="${TASK_ARGS[*]}"
args_string="${args_string// /,}"

docker run \
       -u "$(id -u)" \
       --env "RUBY_VERSION=${RUBY_VERSION}" \
       --env "WORKFLOW=${WORKFLOW}" \
       --name test-runner \
       --volume "${repo}:/usr/src/app" \
       --rm \
       "${product}" \
       bundle exec rake automation:${TASK}["${args_string}"]

# ------------------------------------------------------- #
# Post Command tasks & checks
# ------------------------------------------------------- #
if [[ "$CMD" == "docsgen" ]]; then
    echo "TODO"
fi

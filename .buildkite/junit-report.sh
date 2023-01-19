#!/usr/bin/env bash
#
# Script to run npm's xunit-viewer to view JUnit test reports
#
echo "--- JUnit Report"
# The directorty where the JUnit report is stored
buildkite-agent artifact download "elasticsearch-api/tmp/*.xml" .
repo=`pwd`
script_path=$(dirname $(realpath -s $0))

docker build --file $script_path/Dockerfile-JUnit -t junit-report .

docker run \
       --volume $repo:/usr/src/app \
       --mount type=bind,source=$repo/elasticsearch-api/tmp,target=/usr/src/app/elasticsearch-api/tmp,bind-propagation=shared \
       --rm \
       junit-report

echo "PWD: `pwd`"
echo "ls outside container"
ls elasticsearch-api/tmp

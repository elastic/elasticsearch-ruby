#!/usr/bin/env bash
#
# This script is intended to be run after the build in a Buildkite pipeline
buildkite-agent annotate --style info "## :rspec: Tests summary :rspec:
"
buildkite-agent artifact download "elasticsearch-api/tmp/*" .

files="elasticsearch-api/tmp/*.log"
for f in $files; do
  RUBY_VERSION=`echo $f | grep -Po "(j?ruby-|\d+\.)+\d+" | tail -1`
  TRANSPORT_VERSION=`echo $f | grep -Po "transport-([\d.]+|main)"`
  buildkite-agent annotate --append "
:ruby: $RUBY_VERSION :phone: $TRANSPORT_VERSION `tail --lines=2 $f | awk -F "-- :" '{print $2}'`

"

  FAILED_TESTS=`grep "E," $f`
  if [[ -n "$FAILED_TESTS" ]]; then
    buildkite-agent annotate --append "#### Failures in $f "
    buildkite-agent annotate --append `grep "E," $f | awk -F '-- :' '{print $2}'`
  fi
done

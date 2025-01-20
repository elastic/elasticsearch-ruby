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

  FAILED_TESTS=`grep -A1 "E,.*" $f | sed 's/\#/-/g' | sed 's/^--/\n/g'`
  if [[ -n "$FAILED_TESTS" ]]; then
    buildkite-agent annotate --append "<details>"
    buildkite-agent annotate --append "<summary>:x: Failures in $f</summary>
$FAILED_TESTS
</details>"
  fi
done

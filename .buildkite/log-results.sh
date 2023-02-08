#!/usr/bin/env bash
#
# This script is intended to be run after the build in a Buildkite pipeline
echo "--- Test summary"
buildkite-agent artifact download "elasticsearch-api/tmp/*.html" .

files="elasticsearch-api/tmp/*.html"
for f in $files; do
  TEST_SUITE=`echo $f | grep -o "\(free\|platinum\)"`
  RUBY_VERSION=`echo $f | grep -Po "(\d+\.)+\d+"`
  EXAMPLES=`cat $f | grep -o "[0-9]\+ examples\?" | tail -1`
  FAILURES=`cat $f | grep -o "[0-9]\+ failures\?" | tail -1`
  PENDING=`cat $f | grep -o "[0-9]\+ pending" | tail -1`
  echo "--- :ruby: $RUBY_VERSION :test_tube: $TEST_SUITE :rspec: $EXAMPLES - :x: $FAILURES - :pinched_fingers: $PENDING"
done

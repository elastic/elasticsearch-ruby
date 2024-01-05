#!/usr/bin/env bash
#
# This script is intended to be run after the build in a Buildkite pipeline
buildkite-agent annotate --style info "## :rspec: Tests summary :rspec:
"
buildkite-agent artifact download "elasticsearch-api/tmp/*" .

# Test result summary:
files="elasticsearch-api/tmp/*.html"
for f in $files; do
  TEST_SUITE=`echo $f | grep -o "\(free\|platinum\)"`
  RUBY_VERSION=`echo $f | grep -Po "(jruby-|\d+\.)+\d+"`
  EXAMPLES=`cat $f | grep -o "[0-9]\+ examples\?" | tail -1`
  FAILURES=`cat $f | grep -o "[0-9]\+ failures\?" | tail -1`
  PENDING=`cat $f | grep -o "[0-9]\+ pending" | tail -1`
  buildkite-agent annotate --append "
:ruby: $RUBY_VERSION :test_tube: $TEST_SUITE :rspec: $EXAMPLES - :x: $FAILURES - :suspect: $PENDING
"
done

# Failed tests:
files="elasticsearch-api/tmp/*.log"
for f in $files; do
  FAILED_TESTS=`awk 'BEGIN { FS = " | "}; /\| failed \|/{ print $1 }' $f | uniq`
  if [[ -n "$FAILED_TESTS" ]]; then
    buildkite-agent annotate --append "
#### Failures in $f
"
    FAILURES_ARRAY=($(echo $FAILED_TESTS | tr ' ' "\n"))
    for f in "${FAILURES_ARRAY[@]}"
    do
      buildkite-agent annotate --append "
- $f
"
    done
  fi
done

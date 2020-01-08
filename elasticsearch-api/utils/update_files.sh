#!/bin/sh
echo "Copying generated files into lib..."
cp ../tmp/out/api/* ../lib/elasticsearch/api/actions/ -R
echo "Running Rubocop..."
rubocop -x ../lib/elasticsearch/api/actions

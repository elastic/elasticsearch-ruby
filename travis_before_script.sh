#!/bin/bash


if [ "${TEST_SUITE}" == "integration" ]; then

    metadata_url="https://artifacts-api.elastic.co/v1/branches/master/builds/latest/projects/elasticsearch/packages/elasticsearch-${ELASTICSEARCH_VERSION}-SNAPSHOT.zip/file"
    echo "Getting snapshot location from $metadata_url"

    url=$(curl -v $metadata_url 2>&1 | grep -Pio 'location: \K(.*)' | tr -d '\r')

    echo "Downloading Elasticsearch from $url"
    curl $url -o /tmp/elasticsearch.zip

    echo 'Unzipping file'
    unzip -q /tmp/elasticsearch.zip

    echo "Starting elasticsearch on port ${TEST_CLUSTER_PORT}"

    curl http://localhost:9250

    ${PWD}/elasticsearch-7.0.0-alpha1-SNAPSHOT/bin/elasticsearch -E cluster.name=elasticsearch_test -E node.name=node-1 -E http.port=9250 -E path.data=data1 -E path.logs=log1 &> /dev/null &
    ${PWD}/elasticsearch-7.0.0-alpha1-SNAPSHOT/bin/elasticsearch -E cluster.name=elasticsearch_test -E node.name=node-2 -E http.port=9251 -E path.data=data2 -E path.logs=log2 &> /dev/null &

    sleep 5
    bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9250/_cluster/health?wait_for_status=green&timeout=50s)" != "200" ]]; do sleep 5; done'
    bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:9251/_cluster/health?wait_for_status=green&timeout=50s)" != "200" ]]; do sleep 5; done'
    curl http://localhost:9250
    curl http://localhost:9251
fi

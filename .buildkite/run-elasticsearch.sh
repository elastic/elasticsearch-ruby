#!/usr/bin/env bash
#
# Launch one or more Elasticsearch nodes via the Docker image,
# to form a cluster suitable for running the REST API tests.
#

# Setup
script_path=$(dirname $(realpath -s $0))
source $script_path/wait-for-container.sh
export TEST_SUITE=${TEST_SUITE-free}
export ES_NODE_NAME=es01
export elastic_password=changeme
export elasticsearch_image=elasticsearch
export elasticsearch_scheme="https"
if [[ $TEST_SUITE != "platinum" ]]; then
  export elasticsearch_scheme="http"
fi
export elasticsearch_url=${elasticsearch_scheme}://elastic:${elastic_password}@${ES_NODE_NAME}:9200
export external_elasticsearch_url=${elasticsearch_url/$ES_NODE_NAME/localhost}
export elasticsearch_container="${elasticsearch_image}:${STACK_VERSION}"
export suffix=rest-test
export moniker=$(echo "$elasticsearch_container" | tr -C "[:alnum:]" '-')
export cluster_name=${moniker}${suffix}
export network_name='elastic'
# Certificates
export ssl_cert="${script_path}/certs/testnode.crt"
export ssl_key="${script_path}/certs/testnode.key"
export ssl_ca="${script_path}/certs/ca.crt"

declare -a volumes
environment=($(cat <<-END
  --env ELASTIC_PASSWORD=$elastic_password
  --env node.name=$ES_NODE_NAME
  --env cluster.name=$cluster_name
  --env cluster.routing.allocation.disk.threshold_enabled=false
  --env bootstrap.memory_lock=true
  --env node.attr.testattr=test
  --env path.repo=/tmp
  --env repositories.url.allowed_urls=http://snapshot.test*
  --env action.destructive_requires_name=false
  --env ingest.geoip.downloader.enabled=false
  --env cluster.deprecation_indexing.enabled=false
END
#  --env cluster.initial_master_nodes=$master_node_name
#  --env discovery.seed_hosts=$master_node_name
))
if [[ "$TEST_SUITE" == "platinum" ]]; then
  environment+=($(cat <<-END
    --env xpack.license.self_generated.type=trial
    --env xpack.security.http.ssl.enabled=true
    --env xpack.security.http.ssl.verification_mode=certificate
    --env xpack.security.http.ssl.key=certs/testnode.key
    --env xpack.security.http.ssl.certificate=certs/testnode.crt
    --env xpack.security.http.ssl.certificate_authorities=certs/ca.crt
    --env xpack.security.transport.ssl.enabled=true
    --env xpack.security.transport.ssl.verification_mode=certificate
    --env xpack.security.transport.ssl.key=certs/testnode.key
    --env xpack.security.transport.ssl.certificate=certs/testnode.crt
    --env xpack.security.transport.ssl.certificate_authorities=certs/ca.crt
END
))
  volumes+=($(cat <<-END
    --volume $ssl_cert:/usr/share/elasticsearch/config/certs/testnode.crt
    --volume $ssl_key:/usr/share/elasticsearch/config/certs/testnode.key
    --volume $ssl_ca:/usr/share/elasticsearch/config/certs/ca.crt
END
))
else
  environment+=($(cat <<-END
    --env node.roles=data,data_cold,data_content,data_frozen,data_hot,data_warm,ingest,master,ml,remote_cluster_client,transform
    --env xpack.security.enabled=false
END
))
fi

cert_validation_flags=""
if [[ "$TEST_SUITE" == "platinum" ]]; then
  cert_validation_flags="--insecure --cacert /usr/share/elasticsearch/config/certs/ca.crt --resolve ${es_node_name}:443:127.0.0.1"
fi


# Pull the container, retry on failures up to 5 times with
# short delays between each attempt. Fixes most transient network errors.
docker_pull_attempts=0
until [ "$docker_pull_attempts" -ge 5 ]
do
  docker pull docker.elastic.co/elasticsearch/elasticsearch:$STACK_VERSION && break
  docker_pull_attempts=$((docker_pull_attempts+1))
  echo "Failed to pull image, retrying in 10 seconds (retry $docker_pull_attempts/5)..."
  sleep 10
done

docker run --name $ES_NODE_NAME \
       -u "$(id -u)" \
       --network elastic \
       --env "ES_JAVA_OPTS=-Xms1g -Xmx1g -da:org.elasticsearch.xpack.ccr.index.engine.FollowingEngineAssertions" \
       "${environment[@]}" \
       "${volumes[@]}" \
       --publish 9200:9200 \
       --ulimit nofile=65536:65536 \
       --ulimit memlock=-1:-1 \
       --detach=$DETACH \
       --health-cmd="curl $cert_validation_flags --fail $elasticsearch_url/_cluster/health || exit 1" \
       --health-interval=2s \
       --health-retries=20 \
       --health-timeout=2s \
       --rm \
       docker.elastic.co/elasticsearch/elasticsearch:$STACK_VERSION
set +x
if wait_for_container "$ES_NODE_NAME" elastic; then
  echo "--- :elasticsearch: Elasticsearch is running :+1:"
  echo -e "\033[32;1mSUCCESS:\033[0m Running on: $node_url\033[0m"
fi

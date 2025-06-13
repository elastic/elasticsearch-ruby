# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Cluster
      module Actions
        # Update the cluster settings.
        # Configure and update dynamic settings on a running cluster.
        # You can also configure dynamic settings locally on an unstarted or shut down node in `elasticsearch.yml`.
        # Updates made with this API can be persistent, which apply across cluster restarts, or transient, which reset after a cluster restart.
        # You can also reset transient or persistent settings by assigning them a null value.
        # If you configure the same setting using multiple methods, Elasticsearch applies the settings in following order of precedence: 1) Transient setting; 2) Persistent setting; 3) `elasticsearch.yml` setting; 4) Default setting value.
        # For example, you can apply a transient setting to override a persistent setting or `elasticsearch.yml` setting.
        # However, a change to an `elasticsearch.yml` setting will not override a defined transient or persistent setting.
        # TIP: In Elastic Cloud, use the user settings feature to configure all cluster settings. This method automatically rejects unsafe settings that could break your cluster.
        # If you run Elasticsearch on your own hardware, use this API to configure dynamic cluster settings.
        # Only use `elasticsearch.yml` for static cluster settings and node settings.
        # The API doesn’t require a restart and ensures a setting’s value is the same on all nodes.
        # WARNING: Transient cluster settings are no longer recommended. Use persistent cluster settings instead.
        # If a cluster becomes unstable, transient settings can clear unexpectedly, resulting in a potentially undesired cluster configuration.
        #
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node Server default: 30s.
        # @option arguments [Time] :timeout Explicit operation timeout Server default: 30s.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-cluster-put-settings
        #
        def put_settings(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.put_settings' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_PUT
          path   = '_cluster/settings'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

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
    module Actions
      # Ping the cluster.
      # Get information about whether the cluster is running.
      #
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/group/endpoint-cluster
      #
      def ping(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'ping' }

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        method = Elasticsearch::API::HTTP_HEAD
        path   = ''
        params = {}

        begin
          perform_request(method, path, params, body, headers, request_opts).status == 200
        rescue Exception => e
          raise e unless e.class.to_s =~ /NotFound|ConnectionFailed/ || e.message =~ /Not *Found|404|ConnectionFailed/i

          false
        end
      end
    end
  end
end

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
    module Ingest
      module Actions
        # Get GeoIP statistics.
        # Get download statistics for GeoIP2 databases that are used with the GeoIP processor.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/geoip-processor.html
        #
        def geo_ip_stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ingest.geo_ip_stats' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_ingest/geoip/stats'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

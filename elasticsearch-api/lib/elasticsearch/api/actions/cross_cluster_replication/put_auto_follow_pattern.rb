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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module CrossClusterReplication
      module Actions
        # Creates a new named collection of auto-follow patterns against a specified remote cluster. Newly created indices on the remote cluster matching any of the specified patterns will be automatically configured as follower indices.
        #
        # @option arguments [String] :name The name of the auto follow pattern.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The specification of the auto follow pattern (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ccr-put-auto-follow-pattern.html
        #
        def put_auto_follow_pattern(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_ccr/auto_follow/#{Utils.__listify(_name)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end

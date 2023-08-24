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
    module IndexLifecycleManagement
      module Actions
        # Deletes the specified lifecycle policy definition. A currently used policy cannot be deleted.
        #
        # @option arguments [String] :policy The name of the index lifecycle policy
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ilm-delete-lifecycle.html
        #
        def delete_lifecycle(arguments = {})
          raise ArgumentError, "Required argument 'policy' missing" unless arguments[:policy]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _policy = arguments.delete(:policy)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ilm/policy/#{Utils.__listify(_policy)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end

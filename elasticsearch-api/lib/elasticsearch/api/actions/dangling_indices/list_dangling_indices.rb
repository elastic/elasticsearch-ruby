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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module DanglingIndices
      module Actions
        # Get the dangling indices.
        # If Elasticsearch encounters index data that is absent from the current cluster state, those indices are considered to be dangling.
        # For example, this can happen if you delete more than +cluster.indices.tombstones.size+ indices while an Elasticsearch node is offline.
        # Use this API to list dangling indices, which you can then import or delete.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-dangling-indices-list-dangling-indices
        #
        def list_dangling_indices(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'dangling_indices.list_dangling_indices' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_dangling'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

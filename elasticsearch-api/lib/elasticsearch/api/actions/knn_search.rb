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

module Elasticsearch
  module API
    module Actions
      # Performs a kNN search.
      # This functionality is Experimental and may be changed or removed
      # completely in a future release. Elastic will take a best effort approach
      # to fix any issues, but experimental features are not subject to the
      # support SLA of official GA features.
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [List] :routing A comma-separated list of specific routing values
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The search definition
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/search-search.html
      #
      def knn_search(arguments = {})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        arguments = arguments.clone

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = "#{Utils.__listify(_index)}/_knn_search"
        params = Utils.process_params(arguments)

        perform_request(method, path, params, body, headers).body
      end
    end
  end
end

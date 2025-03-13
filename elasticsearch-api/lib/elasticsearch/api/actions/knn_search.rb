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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Actions
      # Run a knn search.
      # NOTE: The kNN search API has been replaced by the +knn+ option in the search API.
      # Perform a k-nearest neighbor (kNN) search on a dense_vector field and return the matching documents.
      # Given a query vector, the API finds the k closest vectors and returns those documents as search hits.
      # Elasticsearch uses the HNSW algorithm to support efficient kNN search.
      # Like most kNN algorithms, HNSW is an approximate method that sacrifices result accuracy for improved search speed.
      # This means the results returned are not always the true k closest neighbors.
      # The kNN search API supports restricting the search using a filter.
      # The search will return the top k documents that also match the filter query.
      # A kNN search response has the exact same structure as a search API response.
      # However, certain sections have a meaning specific to kNN search:
      # * The document +_score+ is determined by the similarity between the query and document vector.
      # * The +hits.total+ object contains the total number of nearest neighbor candidates considered, which is +num_candidates * num_shards+. The +hits.total.relation+ will always be +eq+, indicating an exact value.
      # This functionality is Experimental and may be changed or removed
      # completely in a future release. Elastic will take a best effort approach
      # to fix any issues, but experimental features are not subject to the
      # support SLA of official GA features.
      #
      # @option arguments [String, Array] :index A comma-separated list of index names to search;
      #  use +_all+ or to perform the operation on all indices. (*Required*)
      # @option arguments [String] :routing A comma-separated list of specific routing values.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/knn-search-api.html
      #
      def knn_search(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'knn_search' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = "#{Utils.listify(_index)}/_knn_search"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end

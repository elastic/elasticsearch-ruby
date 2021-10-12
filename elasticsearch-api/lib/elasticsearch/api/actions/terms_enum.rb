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
      # The terms enum API  can be used to discover terms in the index that begin with the provided string. It is designed for low-latency look-ups used in auto-complete scenarios.
      #
      # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body field name, string which is the prefix expected in matching terms, timeout and size for max number of results
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-terms-enum.html
      #
      def terms_enum(arguments = {})
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

        path   = "#{Utils.__listify(_index)}/_terms_enum"
        params = {}

        perform_request(method, path, params, body, headers).body
      end
    end
  end
end

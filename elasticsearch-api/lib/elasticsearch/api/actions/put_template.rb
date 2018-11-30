# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

      # Store a template for the search definition in Elasticsearch,
      # to be later used with the `search_template` method
      #
      # @option arguments [String] :id Template ID (*Required*)
      # @option arguments [Hash] :body The document (*Required*)
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-template.html
      #
      def put_template(arguments={})
        raise ArgumentError, "Required argument 'id' missing"   unless arguments[:id]
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = HTTP_POST
        path   = "_scripts/#{arguments[:id]}"
        params = {}
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end

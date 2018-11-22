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

      # Retrieve an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Template ID (*Required*)
      # @option arguments [Hash] :body The document
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-template.html
      #
      def get_template(arguments={})
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
        method = HTTP_GET
        path   = "_search/template/#{arguments[:id]}"
        params = {}
        body   = arguments[:body]

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        else
          perform_request(method, path, params, body).body
        end
      end
    end
  end
end

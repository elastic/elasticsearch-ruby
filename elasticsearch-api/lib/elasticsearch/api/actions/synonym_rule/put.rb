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
    module SynonymRule
      module Actions
        # Creates or updates a synonym rule in a synonym set
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :synonyms_set The id of the synonym set to be updated with the synonym rule
        # @option arguments [String] :synonym_rule The id of the synonym rule to be updated or created
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Synonym rule (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.9/put-synonym-rule.html
        #
        def put(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'synonyms_set' missing" unless arguments[:synonyms_set]
          raise ArgumentError, "Required argument 'synonym_rule' missing" unless arguments[:synonym_rule]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _synonyms_set = arguments.delete(:synonyms_set)

          _synonym_rule = arguments.delete(:synonym_rule)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_synonyms/#{Utils.__listify(_synonyms_set)}/#{Utils.__listify(_synonym_rule)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end

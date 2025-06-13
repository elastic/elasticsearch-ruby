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
    module Synonyms
      module Actions
        # Delete a synonym set.
        # You can only delete a synonyms set that is not in use by any index analyzer.
        # Synonyms sets can be used in synonym graph token filters and synonym token filters.
        # These synonym filters can be used as part of search analyzers.
        # Analyzers need to be loaded when an index is restored (such as when a node starts, or the index becomes open).
        # Even if the analyzer is not used on any field mapping, it still needs to be loaded on the index recovery phase.
        # If any analyzers cannot be loaded, the index becomes unavailable and the cluster status becomes red or yellow as index shards are not available.
        # To prevent that, synonyms sets that are used in analyzers can't be deleted.
        # A delete request in this case will return a 400 response code.
        # To remove a synonyms set, you must first remove all indices that contain analyzers using it.
        # You can migrate an index by creating a new index that does not contain the token filter with the synonyms set, and use the reindex API in order to copy over the index data.
        # Once finished, you can delete the index.
        # When the synonyms set is not used in analyzers, you will be able to delete it.
        #
        # @option arguments [String] :id The synonyms set identifier to delete. (*Required*)
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-synonyms-delete-synonym
        #
        def delete_synonym(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'synonyms.delete_synonym' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_synonyms/#{Utils.listify(_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

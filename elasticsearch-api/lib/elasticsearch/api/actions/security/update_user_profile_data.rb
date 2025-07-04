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
    module Security
      module Actions
        # Update user profile data.
        # Update specific data for the user profile that is associated with a unique ID.
        # NOTE: The user profile feature is designed only for use by Kibana and Elastic's Observability, Enterprise Search, and Elastic Security solutions.
        # Individual users and external applications should not call this API directly.
        # Elastic reserves the right to change or remove this feature in future releases without prior notice.
        # To use this API, you must have one of the following privileges:
        # * The `manage_user_profile` cluster privilege.
        # * The `update_profile_data` global privilege for the namespaces that are referenced in the request.
        # This API updates the `labels` and `data` fields of an existing user profile document with JSON objects.
        # New keys and their values are added to the profile document and conflicting keys are replaced by data that's included in the request.
        # For both labels and data, content is namespaced by the top-level fields.
        # The `update_profile_data` global privilege grants privileges for updating only the allowed namespaces.
        #
        # @option arguments [String] :uid A unique identifier for the user profile. (*Required*)
        # @option arguments [Integer] :if_seq_no Only perform the operation if the document has this sequence number.
        # @option arguments [Integer] :if_primary_term Only perform the operation if the document has this primary term.
        # @option arguments [String] :refresh If 'true', Elasticsearch refreshes the affected shards to make this operation
        #  visible to search.
        #  If 'wait_for', it waits for a refresh to make this operation visible to search.
        #  If 'false', nothing is done with refreshes. Server default: false.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-update-user-profile-data
        #
        def update_user_profile_data(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.update_user_profile_data' }

          defined_params = [:uid].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'uid' missing" unless arguments[:uid]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _uid = arguments.delete(:uid)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_security/profile/#{Utils.listify(_uid)}/_data"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

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
        # Get API key information.
        # Retrieves information for one or more API keys.
        # NOTE: If you have only the `manage_own_api_key` privilege, this API returns only the API keys that you own.
        # If you have `read_security`, `manage_api_key` or greater privileges (including `manage_security`), this API returns all API keys regardless of ownership.
        #
        # @option arguments [String] :id An API key id.
        #  This parameter cannot be used with any of `name`, `realm_name` or `username`.
        # @option arguments [String] :name An API key name.
        #  This parameter cannot be used with any of `id`, `realm_name` or `username`.
        #  It supports prefix search with wildcard.
        # @option arguments [Boolean] :owner A boolean flag that can be used to query API keys owned by the currently authenticated user.
        #  The `realm_name` or `username` parameters cannot be specified when this parameter is set to `true` as they are assumed to be the currently authenticated ones.
        # @option arguments [String] :realm_name The name of an authentication realm.
        #  This parameter cannot be used with either `id` or `name` or when `owner` flag is set to `true`.
        # @option arguments [String] :username The username of a user.
        #  This parameter cannot be used with either `id` or `name` or when `owner` flag is set to `true`.
        # @option arguments [Boolean] :with_limited_by Return the snapshot of the owner user's role descriptors
        #  associated with the API key. An API key's actual
        #  permission is the intersection of its assigned role
        #  descriptors and the owner user's role descriptors.
        # @option arguments [Boolean] :active_only A boolean flag that can be used to query API keys that are currently active. An API key is considered active if it is neither invalidated, nor expired at query time. You can specify this together with other parameters such as `owner` or `name`. If `active_only` is false, the response will include both active and inactive (expired or invalidated) keys.
        # @option arguments [Boolean] :with_profile_uid Determines whether to also retrieve the profile uid, for the API key owner principal, if it exists.
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
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-get-api-key
        #
        def get_api_key(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.get_api_key' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_security/api_key'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

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
    module Security
      module Actions
        # Create or update application privileges.
        # To use this API, you must have one of the following privileges:
        # * The +manage_security+ cluster privilege (or a greater privilege such as +all+).
        # * The "Manage Application Privileges" global privilege for the application being referenced in the request.
        # Application names are formed from a prefix, with an optional suffix that conform to the following rules:
        # * The prefix must begin with a lowercase ASCII letter.
        # * The prefix must contain only ASCII letters or digits.
        # * The prefix must be at least 3 characters long.
        # * If the suffix exists, it must begin with either a dash +-+ or +_+.
        # * The suffix cannot contain any of the following characters: +\+, +/+, +*+, +?+, +"+, +<+, +>+, +|+, +,+, +*+.
        # * No part of the name can contain whitespace.
        # Privilege names must begin with a lowercase ASCII letter and must contain only ASCII letters and digits along with the characters +_+, +-+, and +.+.
        # Action names can contain any number of printable ASCII characters and must contain at least one of the following characters: +/+, +*+, +:+.
        #
        # @option arguments [String] :refresh If +true+ (the default) then refresh the affected shards to make this operation visible to search, if +wait_for+ then wait for a refresh to make this operation visible to search, if +false+ then do nothing with refreshes.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body privileges
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-privileges
        #
        def put_privileges(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.put_privileges' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_PUT
          path   = '_security/privilege'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

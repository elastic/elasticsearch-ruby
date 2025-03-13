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
    module Watcher
      module Actions
        # Create or update a watch.
        # When a watch is registered, a new document that represents the watch is added to the +.watches+ index and its trigger is immediately registered with the relevant trigger engine.
        # Typically for the +schedule+ trigger, the scheduler is the trigger engine.
        # IMPORTANT: You must use Kibana or this API to create a watch.
        # Do not add a watch directly to the +.watches+ index by using the Elasticsearch index API.
        # If Elasticsearch security features are enabled, do not give users write privileges on the +.watches+ index.
        # When you add a watch you can also define its initial active state by setting the *active* parameter.
        # When Elasticsearch security features are enabled, your watch can index or search only on indices for which the user that stored the watch has privileges.
        # If the user is able to read index +a+, but not index +b+, the same will apply when the watch runs.
        #
        # @option arguments [String] :id The identifier for the watch. (*Required*)
        # @option arguments [Boolean] :active The initial state of the watch.
        #  The default value is +true+, which means the watch is active by default. Server default: true.
        # @option arguments [Integer] :if_primary_term only update the watch if the last operation that has changed the watch has the specified primary term
        # @option arguments [Integer] :if_seq_no only update the watch if the last operation that has changed the watch has the specified sequence number
        # @option arguments [Integer] :version Explicit version number for concurrency control
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-watcher-put-watch
        #
        def put_watch(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'watcher.put_watch' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_watcher/watch/#{Utils.listify(_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

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
        # Run a watch.
        # This API can be used to force execution of the watch outside of its triggering logic or to simulate the watch execution for debugging purposes.
        # For testing and debugging purposes, you also have fine-grained control on how the watch runs.
        # You can run the watch without running all of its actions or alternatively by simulating them.
        # You can also force execution by ignoring the watch condition and control whether a watch record would be written to the watch history after it runs.
        # You can use the run watch API to run watches that are not yet registered by specifying the watch definition inline.
        # This serves as great tool for testing and debugging your watches prior to adding them to Watcher.
        # When Elasticsearch security features are enabled on your cluster, watches are run with the privileges of the user that stored the watches.
        # If your user is allowed to read index +a+, but not index +b+, then the exact same set of rules will apply during execution of a watch.
        # When using the run watch API, the authorization data of the user that called the API will be used as a base, instead of the information who stored the watch.
        #
        # @option arguments [String] :id The watch identifier.
        # @option arguments [Boolean] :debug Defines whether the watch runs in debug mode.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-watcher-execute-watch
        #
        def execute_watch(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'watcher.execute_watch' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _id
                     "_watcher/watch/#{Utils.listify(_id)}/_execute"
                   else
                     '_watcher/watch/_execute'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

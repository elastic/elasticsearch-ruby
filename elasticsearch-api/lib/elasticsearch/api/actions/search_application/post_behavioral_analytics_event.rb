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
    module SearchApplication
      module Actions
        # Create a behavioral analytics collection event.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :collection_name The name of the behavioral analytics collection. (*Required*)
        # @option arguments [String] :event_type The analytics event type. (*Required*)
        # @option arguments [Boolean] :debug Whether the response type has to include more details
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body payload
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search-application-post-behavioral-analytics-event
        #
        def post_behavioral_analytics_event(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'search_application.post_behavioral_analytics_event' }

          defined_params = [:collection_name, :event_type].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'collection_name' missing" unless arguments[:collection_name]
          raise ArgumentError, "Required argument 'event_type' missing" unless arguments[:event_type]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _collection_name = arguments.delete(:collection_name)

          _event_type = arguments.delete(:event_type)

          method = Elasticsearch::API::HTTP_POST
          path   = "_application/analytics/#{Utils.listify(_collection_name)}/event/#{Utils.listify(_event_type)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

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
    module SearchableSnapshots
      module Actions
        # Mount a snapshot as a searchable index.
        #
        # @option arguments [String] :repository The name of the repository containing the snapshot of the index to mount
        # @option arguments [String] :snapshot The name of the snapshot of the index to mount
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :wait_for_completion Should this request wait until the operation has completed before returning
        # @option arguments [String] :storage Selects the kind of local storage used to accelerate searches. Experimental, and defaults to `full_copy`
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The restore configuration for mounting the snapshot as searchable (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/searchable-snapshots-api-mount-snapshot.html
        #
        def mount(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.__listify(_repository)}/#{Utils.__listify(_snapshot)}/_mount"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end

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
    module Transform
      module Actions
        # Create a transform.
        # Creates a transform.
        # A transform copies data from source indices, transforms it, and persists it into an entity-centric destination index. You can also think of the destination index as a two-dimensional tabular data structure (known as
        # a data frame). The ID for each document in the data frame is generated from a hash of the entity, so there is a
        # unique row per entity.
        # You must choose either the latest or pivot method for your transform; you cannot use both in a single transform. If
        # you choose to use the pivot method for your transform, the entities are defined by the set of +group_by+ fields in
        # the pivot object. If you choose to use the latest method, the entities are defined by the +unique_key+ field values
        # in the latest object.
        # You must have +create_index+, +index+, and +read+ privileges on the destination index and +read+ and
        # +view_index_metadata+ privileges on the source indices. When Elasticsearch security features are enabled, the
        # transform remembers which roles the user that created it had at the time of creation and uses those same roles. If
        # those roles do not have the required privileges on the source and destination indices, the transform fails when it
        # attempts unauthorized operations.
        # NOTE: You must use Kibana or this API to create a transform. Do not add a transform directly into any
        # +.transform-internal*+ indices using the Elasticsearch index API. If Elasticsearch security features are enabled, do
        # not give users any privileges on +.transform-internal*+ indices. If you used transforms prior to 7.5, also do not
        # give users any privileges on +.data-frame-internal*+ indices.
        #
        # @option arguments [String] :transform_id Identifier for the transform. This identifier can contain lowercase alphanumeric characters (a-z and 0-9),
        #  hyphens, and underscores. It has a 64 character limit and must start and end with alphanumeric characters. (*Required*)
        # @option arguments [Boolean] :defer_validation When the transform is created, a series of validations occur to ensure its success. For example, there is a
        #  check for the existence of the source indices and a check that the destination index is not part of the source
        #  index pattern. You can use this parameter to skip the checks, for example when the source index does not exist
        #  until after the transform is created. The validations are always run when you start the transform, however, with
        #  the exception of privilege checks.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-put-transform
        #
        def put_transform(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.put_transform' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_transform/#{Utils.listify(_transform_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

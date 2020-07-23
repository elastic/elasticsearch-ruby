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

module Elasticsearch
  module XPack
    module API
      module Cat
        module Actions
          # Gets configuration and usage information about transforms.
          #
          # @option arguments [String] :transform_id The id of the transform for which to get stats. '_all' or '*' implies all transforms
          # @option arguments [Int] :from skips a number of transform configs, defaults to 0
          # @option arguments [Int] :size specifies a max number of transforms to get, defaults to 100
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)
          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          # @option arguments [List] :h Comma-separated list of column names to display
          # @option arguments [Boolean] :help Return help information
          # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
          # @option arguments [String] :time The unit in which to display time values
          #   (options: d,h,m,s,ms,micros,nanos)
          # @option arguments [Boolean] :v Verbose mode. Display column headers
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/cat-transforms.html
          #
          def transforms(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _transform_id
                       "_cat/transforms/#{Elasticsearch::API::Utils.__listify(_transform_id)}"
                     else
                       "_cat/transforms"
                     end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:transforms, [
            :from,
            :size,
            :allow_no_match,
            :format,
            :h,
            :help,
            :s,
            :time,
            :v
          ].freeze)
        end
      end
    end
  end
end

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
  module API
    module Cat
      module Actions
        # Shows how much heap memory is currently being used by fielddata on every data node in the cluster.
        #
        # @option arguments [List] :fields A comma-separated list of fields to return the fielddata size
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/cat-fielddata.html
        #
        def fielddata(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _fields = arguments.delete(:fields)

          method = Elasticsearch::API::HTTP_GET
          path   = if _fields
                     "_cat/fielddata/#{Utils.__listify(_fields)}"
                   else
                     "_cat/fielddata"
                   end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:fielddata, [
          :format,
          :bytes,
          :h,
          :help,
          :s,
          :v,
          :fields
        ].freeze)
      end
    end
  end
end

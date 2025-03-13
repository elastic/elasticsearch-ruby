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
    module Cat
      module Actions
        # Get aliases.
        # Get the cluster's index aliases, including filter and routing information.
        # This API does not return data stream aliases.
        # IMPORTANT: CAT APIs are only intended for human consumption using the command line or the Kibana console. They are not intended for use by applications. For application consumption, use the aliases API.
        #
        # @option arguments [String, Array<String>] :name A comma-separated list of aliases to retrieve. Supports wildcards (+*+).  To retrieve all aliases, omit this parameter or use +*+ or +_all+.
        # @option arguments [String, Array<String>] :h List of columns to appear in the response. Supports simple wildcards.
        # @option arguments [String, Array<String>] :s List of columns that determine how the table should be sorted.
        #  Sorting defaults to ascending and can be changed by setting +:asc+
        #  or +:desc+ as a suffix to the column name.
        # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  It supports comma-separated values, such as +open,hidden+.
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicated that the request should never timeout, you can set it to +-1+. Server default: 30s.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  +text+, +json+, +cbor+, +yaml+, or +smile+. Server default: text.
        # @option arguments [Boolean] :help When set to +true+ will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to +true+ will enable verbose output.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-aliases
        #
        def aliases(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.aliases' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_GET
          path   = if _name
                     "_cat/aliases/#{Utils.listify(_name)}"
                   else
                     '_cat/aliases'
                   end
          params = Utils.process_params(arguments)
          params[:h] = Utils.listify(params[:h]) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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
      module SQL
        module Actions

          # TODO: Description
          #
          # @option arguments [Hash] :body Use the `query` element to start a query. Use the `cursor` element to continue a query. (*Required*)
          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          #
          # @see Execute SQL
          #
          def query(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            valid_params = [
              :format ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/sql"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end

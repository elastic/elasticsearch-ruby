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
  module API
    module Indices
      module Actions

        # Delete all documents and mapping for a specific document type.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` for all indices (*Required*)
        # @option arguments [String] :type The name of the document type to delete (*Required*)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-mapping/
        #
        def delete_mapping(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
          method = HTTP_DELETE
          path   = Utils.__pathify Utils.__listify(arguments[:index]), Utils.__escape(arguments[:type])
          params = {}
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end

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

        # Delete one or more warmers for a list of indices.
        #
        # @example Delete a warmer named _mywarmer_ for index named _myindex_
        #
        #     client.indices.delete_warmer index: 'myindex', name: 'mywarmer'
        #
        # @option arguments [List] :index A comma-separated list of index names to register warmer for; use `_all`
        #                                 or empty string to perform the operation on all indices (*Required*)
        # @option arguments [String] :name The name of the warmer (supports wildcards); leave empty to delete all warmers
        # @option arguments [List] :type A comma-separated list of document types to register warmer for; use `_all`
        #                                or empty string to perform the operation on all types
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-warmers/
        #
        def delete_warmer(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = HTTP_DELETE
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_warmer', Utils.__listify(arguments[:name])
          params = {}
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end

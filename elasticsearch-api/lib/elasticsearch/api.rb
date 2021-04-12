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

require "cgi"
require "multi_json"

require "elasticsearch/api/version"
require "elasticsearch/api/namespace/common"
require "elasticsearch/api/utils"
require "elasticsearch/api/actions/params_registry"

Dir[ File.expand_path('../api/actions/**/params_registry.rb', __FILE__) ].each   { |f| require f }
Dir[ File.expand_path('../api/actions/**/*.rb', __FILE__) ].each   { |f| require f }
Dir[ File.expand_path('../api/namespace/**/*.rb', __FILE__) ].each { |f| require f }

module Elasticsearch
  module API
    DEFAULT_SERIALIZER = MultiJson

    COMMON_PARAMS = [
      :ignore,                        # Client specific parameters
      :index, :type, :id,             # :index/:type/:id
      :body,                          # Request body
      :node_id,                       # Cluster
      :name,                          # Alias, template, settings, warmer, ...
      :field                          # Get field mapping
    ]

    COMMON_QUERY_PARAMS = [
      :ignore,                        # Client specific parameters
      :format,                        # Search, Cat, ...
      :pretty,                        # Pretty-print the response
      :human,                         # Return numeric values in human readable format
      :filter_path,                   # Filter the JSON response
      :opaque_id                      # Use X-Opaque-Id
    ]

    HTTP_GET          = 'GET'.freeze
    HTTP_HEAD         = 'HEAD'.freeze
    HTTP_POST         = 'POST'.freeze
    HTTP_PUT          = 'PUT'.freeze
    HTTP_DELETE       = 'DELETE'.freeze
    UNDERSCORE_SEARCH = '_search'.freeze
    UNDERSCORE_ALL    = '_all'.freeze
    DEFAULT_DOC       = '_doc'.freeze

    # Auto-include all namespaces in the receiver
    #
    def self.included(base)
      base.send :include,
                Elasticsearch::API::Common,
                Elasticsearch::API::Actions,
                Elasticsearch::API::Cluster,
                Elasticsearch::API::Nodes,
                Elasticsearch::API::Indices,
                Elasticsearch::API::Ingest,
                Elasticsearch::API::Snapshot,
                Elasticsearch::API::Tasks,
                Elasticsearch::API::Cat,
                Elasticsearch::API::Remote,
                Elasticsearch::API::DanglingIndices,
                Elasticsearch::API::Features,
                Elasticsearch::API::Shutdown
    end

    # The serializer class
    #
    def self.serializer
      settings[:serializer] || DEFAULT_SERIALIZER
    end

    # Access the module settings
    #
    def self.settings
      @settings ||= {}
    end
  end
end

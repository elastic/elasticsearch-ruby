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

require 'cgi'
require 'multi_json'
require 'elasticsearch/api/version'
require 'elasticsearch/api/utils'
require 'elasticsearch/api/response'

Dir[File.expand_path('api/actions/**/*.rb', __dir__)].each { |f| require f }

module Elasticsearch
  # This is the main module for including all API endpoint functions
  # It includes the namespace modules from ./api/actions
  module API
    include Elasticsearch::API::Actions
    DEFAULT_SERIALIZER = MultiJson

    HTTP_GET          = 'GET'.freeze
    HTTP_HEAD         = 'HEAD'.freeze
    HTTP_POST         = 'POST'.freeze
    HTTP_PUT          = 'PUT'.freeze
    HTTP_DELETE       = 'DELETE'.freeze

    module CommonClient
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def perform_request(method, path, params = {}, body = nil, headers = nil, request_opts = {})
        client.perform_request(method, path, params, body, headers, request_opts)
      end
    end

    # Add new namespaces to this constant
    #
    API_NAMESPACES = [:async_search,
                      :cat,
                      :cross_cluster_replication,
                      :cluster,
                      :connector,
                      :dangling_indices,
                      :enrich,
                      :eql,
                      :esql,
                      :features,
                      :fleet,
                      :graph,
                      :index_lifecycle_management,
                      :indices,
                      :inference,
                      :ingest,
                      :license,
                      :logstash,
                      :migration,
                      :machine_learning,
                      :nodes,
                      :query_rules,
                      :search_application,
                      :searchable_snapshots,
                      :security,
                      :simulate,
                      :snapshot_lifecycle_management,
                      :snapshot,
                      :sql,
                      :ssl,
                      :synonyms,
                      :tasks,
                      :text_structure,
                      :transform,
                      :watcher,
                      :xpack].freeze

    UPPERCASE_APIS = ['sql', 'ssl'].freeze
    API_NAMESPACES.each do |namespace|
      name = namespace.to_s
      module_name = if UPPERCASE_APIS.include?(name)
                      name.upcase
                    elsif name == 'xpack'
                      'XPack'
                    else
                      name.split('_').map(&:capitalize).join
                    end
      class_name = "#{module_name}Client"

      klass = Class.new(Object) do
        include CommonClient, Object.const_get("Elasticsearch::API::#{module_name}::Actions")
      end
      Object.const_set(class_name, klass)
      define_method(name) do
        instance_variable_set("@#{name}", klass.new(self))
      end
    end

    alias ml machine_learning
    alias ilm index_lifecycle_management

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

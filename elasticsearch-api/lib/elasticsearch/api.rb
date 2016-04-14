require "cgi"
require "multi_json"

require "elasticsearch/api/version"
require "elasticsearch/api/namespace/common"
require "elasticsearch/api/utils"

Dir[ File.expand_path('../api/actions/**/*.rb', __FILE__) ].each   { |f| require f }
Dir[ File.expand_path('../api/namespace/**/*.rb', __FILE__) ].each { |f| require f }

module Elasticsearch
  module API

    # A wrapper around MultiJson to handle older versions of the gem.
    # Inspired by a similar class in elasticsearch-transport/lib/elasticsearch/transport/transport/serializer/multi_json.rb
    module MultiJson
      # De-serialize a Hash from JSON string
      #
      def load(string, options={})
        if Gem.loaded_specs['multi_json'].version < Gem::Version.create('1.3.0')
          ::MultiJson.decode(string, options)
        else
          ::MultiJson.load(string, options)
        end
      end
      module_function :load

      # Serialize a Hash to JSON string
      #
      def dump(object, options={})
        if Gem.loaded_specs['multi_json'].version < Gem::Version.create('1.3.0')
          ::MultiJson.encode(object, options)
        else
          ::MultiJson.dump(object, options)
        end
      end
      module_function :dump
    end

    DEFAULT_SERIALIZER = Elasticsearch::API::MultiJson

    COMMON_PARAMS = [
      :ignore,                        # Client specific parameters
      :index, :type, :id,             # :index/:type/:id
      :body,                          # Request body
      :node_id,                       # Cluster
      :name,                          # Alias, template, settings, warmer, ...
      :field                          # Get field mapping
    ]

    COMMON_QUERY_PARAMS = [
      :format,                        # Search, Cat, ...
      :pretty,                        # Pretty-print the response
      :human,                         # Return numeric values in human readable format
      :filter_path                    # Filter the JSON response
    ]

    HTTP_GET          = 'GET'.freeze
    HTTP_HEAD         = 'HEAD'.freeze
    HTTP_POST         = 'POST'.freeze
    HTTP_PUT          = 'PUT'.freeze
    HTTP_DELETE       = 'DELETE'.freeze
    UNDERSCORE_SEARCH = '_search'.freeze
    UNDERSCORE_ALL    = '_all'.freeze

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
                Elasticsearch::API::Cat
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

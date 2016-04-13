module Elasticsearch
  module Transport
    module Transport
      module Serializer

        # An abstract class for implementing serializer implementations
        #
        module Base
          # @param transport [Object] The instance of transport which uses this serializer
          #
          def initialize(transport=nil)
            @transport = transport
          end
        end

        # A default JSON serializer (using [MultiJSON](http://rubygems.org/gems/multi_json))
        #
        class MultiJson
          include Base

          # De-serialize a Hash from JSON string
          #
          def load(string, options={})
            if Gem.loaded_specs['multi_json'].version < Gem::Version.create('1.3.0')
              ::MultiJson.decode(string, options)
            else
              ::MultiJson.load(string, options)
            end
          end

          # Serialize a Hash to JSON string
          #
          def dump(object, options={})
            if Gem.loaded_specs['multi_json'].version < Gem::Version.create('1.3.0')
              ::MultiJson.encode(object, options)
            else
              ::MultiJson.dump(object, options)
            end
          end
        end
      end
    end
  end
end

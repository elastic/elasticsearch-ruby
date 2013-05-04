module Elasticsearch
  module Client
    module Transport
      module Serializer
        module Base
          def initialize(transport=nil)
            @transport = transport
          end
        end

        class MultiJson
          include Base

          def load(string, options={})
            ::MultiJson.load(string, options)
          end

          def dump(object, options={})
            ::MultiJson.dump(object, options)
          end
        end
      end
    end
  end
end

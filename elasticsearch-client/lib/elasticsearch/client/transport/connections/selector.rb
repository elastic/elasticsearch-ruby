module Elasticsearch
  module Client
    module Transport
      module Connections
        module Selector

          module Base
            def initialize(arguments={})
            end
          end

          class Random
            include Base
          end

          class RoundRobin
            include Base
          end

        end
      end
    end
  end
end

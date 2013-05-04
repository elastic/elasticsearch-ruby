module Elasticsearch
  module Client
    module Transport
      module Connections

        class Connection
          attr_reader :host, :connection, :options

          def initialize(arguments={})
            @host, @connection, @options = arguments[:host], arguments[:connection], arguments[:options]
          end

          def full_url(path, params={})
            "#{host[:protocol]}://#{host[:host]}:#{host[:port]}/#{full_path(path, params)}"
          end

          def full_path(path, params={})
            path + (params.empty? ? '' : "?#{::Faraday::Utils::ParamsHash[params].to_query}")
          end

          def to_s
            "<#{self.class.name} host: #{host}>"
          end
        end

      end
    end
  end
end

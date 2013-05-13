module Elasticsearch
  module Client
    module Transport
      module Connections

        class Connection
          DEFAULT_RESURRECT_TIMEOUT = 60

          attr_reader :host, :connection, :options, :failures, :dead_since

          def initialize(arguments={})
            @host       = arguments[:host]
            @connection = arguments[:connection]
            @options    = arguments[:options] || {}

            @options[:resurrect_timeout] ||= DEFAULT_RESURRECT_TIMEOUT
            @failures = 0
          end

          def full_url(path, params={})
            "#{host[:protocol]}://#{host[:host]}:#{host[:port]}/#{full_path(path, params)}"
          end

          def full_path(path, params={})
            path + (params.empty? ? '' : "?#{::Faraday::Utils::ParamsHash[params].to_query}")
          end

          def dead?
            @dead || false
          end

          def dead!
            @dead       = true
            @failures  += 1
            @dead_since = Time.now
            self
          end

          def alive!
            @dead     = false
            self
          end

          def healthy!
            @dead     = false
            @failures = 0
            self
          end

          def resurrect!
            alive! if resurrectable?
          end

          def resurrectable?
            Time.now > @dead_since + ( @options[:resurrect_timeout] * 2 ** (@failures-1) )
          end

          def to_s
            "<#{self.class.name} host: #{host} (#{dead? ? 'dead since ' + dead_since.to_s : 'alive'})>"
          end
        end

      end
    end
  end
end

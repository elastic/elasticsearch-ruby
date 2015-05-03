require "elasticsearch/watcher/version"

Dir[ File.expand_path('../watcher/api/actions/**/*.rb', __FILE__) ].each   { |f| require f }

module Elasticsearch
  module API
    module Watcher
      module Actions; end

        # Client for the "watcher" namespace (includes the {Watcher::Actions} methods)
        #
        class WatcherClient
          include Common::Client, Common::Client::Base, Watcher::Actions
        end

        # Proxy method for {WatcherClient}, available in the receiving object
        #
        def watcher
          @watcher ||= WatcherClient.new(self)
        end
    end
  end
end

Elasticsearch::API.__send__ :include, Elasticsearch::API::Watcher

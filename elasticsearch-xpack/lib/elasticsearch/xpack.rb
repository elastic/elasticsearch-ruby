# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require "elasticsearch/api"
require "elasticsearch/xpack/version"

Dir[ File.expand_path('../xpack/api/actions/**/*.rb', __FILE__) ].each   { |f| require f }
Dir[ File.expand_path('../xpack/api/namespace/**/*.rb', __FILE__) ].each { |f| require f }

module Elasticsearch
  module XPack
    module API
      def self.included(base)
        Elasticsearch::XPack::API.constants.reject {|c| c == :Client }.each do |m|
          base.__send__ :include, Elasticsearch::XPack::API.const_get(m)
        end
      end

      class Client
        include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base
        include Elasticsearch::XPack::API
      end
    end
  end
end

Elasticsearch::API::COMMON_PARAMS.push :job_id, :datafeed_id, :filter_id, :snapshot_id, :category_id

module Elasticsearch
  module Transport
    class Client
      def xpack
        @xpack_client ||= Elasticsearch::XPack::API::Client.new(self)
      end

      def security
        @security ||= xpack.security
      end

      def ml
        @ml ||= xpack.ml
      end
    end
  end
end if defined?(Elasticsearch::Transport::Client)

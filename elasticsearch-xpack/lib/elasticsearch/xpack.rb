# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
    end
  end
end if defined?(Elasticsearch::Transport::Client)

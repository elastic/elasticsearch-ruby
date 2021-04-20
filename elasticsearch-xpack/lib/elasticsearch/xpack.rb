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

require 'elasticsearch/api'
require 'elasticsearch/xpack/version'
require 'elasticsearch/xpack/api/actions/params_registry'

Dir[ File.expand_path('../xpack/api/actions/**/params_registry.rb', __FILE__) ].each   { |f| require f }
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
        include Elasticsearch::API::Common::Client
        include Elasticsearch::API::Common::Client::Base
        include Elasticsearch::XPack::API
      end
    end
  end
end

Elasticsearch::API::COMMON_PARAMS.push :job_id, :datafeed_id, :filter_id, :snapshot_id, :category_id, :policy_id

module Elasticsearch
  module Transport
    class Client
      # When a method is called on the client, if it's one of the xpack root
      # namespace methods, send them to the xpack client.
      # E.g.: client.xpack.usage => client.usage
      # Excluding `info` since OSS and XPACK both have info endpoints.
      TOP_LEVEL_METHODS = [
        :open_point_in_time,
        :close_point_in_time,
        :usage
      ].freeze

      def method_missing(method, *args, &block)
        return xpack.send(method, *args, &block) if TOP_LEVEL_METHODS.include?(method)

        super
      end

      def respond_to_missing?(method_name, *args)
        TOP_LEVEL_METHODS.include?(method_name) || super
      end

      def xpack
        @xpack ||= Elasticsearch::XPack::API::Client.new(self)
      end

      def security
        @security ||= xpack.security
      end

      def ml
        @ml ||= xpack.ml
      end

      def rollup
        @rollup ||= xpack.rollup
      end

      def watcher
        @watcher ||= xpack.watcher
      end

      def graph
        @graph ||= xpack.graph
      end

      def migration
        @migration ||= xpack.migration
      end

      def sql
        @sql ||= xpack.sql
      end

      def deprecation
        @deprecation ||= xpack.deprecation
      end

      def data_frame
        @data_frame ||= xpack.data_frame
      end

      def ilm
        @ilm ||= xpack.ilm
      end

      def license
        @license ||= xpack.license
      end

      def transform
        @transform ||= xpack.transform
      end

      def async_search
        @async_search ||= xpack.async_search
      end

      def cat
        @cat ||= xpack.cat
      end

      def indices
        @indices ||= xpack.indices
      end

      def searchable_snapshots
        @searchable_snapshots ||= xpack.searchable_snapshots
      end

      def cross_cluster_replication
        @cross_cluster_replication ||= xpack.cross_cluster_replication
      end

      def autoscaling
        @autoscaling ||= xpack.autoscaling
      end

      def enrich
        @enrich ||= xpack.enrich
      end

      def eql
        @eql ||= xpack.eql
      end

      def snapshot_lifecycle_management
        @snapshot_lifecycle_management ||= xpack.snapshot_lifecycle_management
      end

      def text_structure
        @text_structure ||= xpack.text_structure
      end

      def logstash
        @logstash ||= xpack.logstash
      end

      def fleet
        @fleet ||= xpack.fleet
      end
    end
  end
end if defined?(Elasticsearch::Transport::Client)

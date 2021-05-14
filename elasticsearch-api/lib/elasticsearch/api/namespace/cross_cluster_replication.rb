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

module Elasticsearch
  module API
    module CrossClusterReplication
      module Actions; end

      # Client for the "cross_cluster_replication" namespace (includes the {CrossClusterReplication::Actions} methods)
      #
      class CrossClusterReplicationClient
        include Common::Client, Common::Client::Base, CrossClusterReplication::Actions
      end

      # Proxy method for {CrossClusterReplicationClient}, available in the receiving object
      #
      def cross_cluster_replication
        @cross_cluster_replication ||= CrossClusterReplicationClient.new(self)
      end

      alias ccr cross_cluster_replication
    end
  end
end

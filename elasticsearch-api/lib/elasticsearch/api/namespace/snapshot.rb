# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Snapshot
      module Actions; end

      # Client for the "snapshot" namespace (includes the {Snapshot::Actions} methods)
      #
      class SnapshotClient
        include Common::Client, Common::Client::Base, Snapshot::Actions
      end

      # Proxy method for {SnapshotClient}, available in the receiving object
      #
      def snapshot
        @snapshot ||= SnapshotClient.new(self)
      end

    end
  end
end

# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Creates a new document in the index.
      #
      # Returns a 409 response when a document with a same ID already exists in the index.
      #
      # @option arguments [String] :id Document ID
      # @option arguments [String] :index The name of the index
      # @option arguments [String] :type The type of the document   *Deprecated*
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the index operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes.
      #   (options: true,false,wait_for)

      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type
      #   (options: internal,external,external_gte)

      # @option arguments [String] :pipeline The pipeline id to preprocess incoming documents with

      # @option arguments [Hash] :body The document (*Required*)
      #
      # *Deprecation notice*:
      # Specifying types in urls has been deprecated
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-index_.html
      #
      def create(arguments = {})
        if arguments[:id]
          index arguments.update op_type: 'create'
        else
          index arguments
        end
      end
    end
    end
end

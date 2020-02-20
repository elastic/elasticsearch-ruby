# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns information and statistics about terms in the fields of a particular document.
      #
      # @option arguments [String] :index The index in which the document resides.  (*Required*)
      # @option arguments [String] :id The id of the document, when not specified a doc param should be supplied.
      # @option arguments [String] :type The type of the document.
      # @option arguments [Boolean] :term_statistics Specifies if total term frequency and document frequency should be returned.
      # @option arguments [Boolean] :field_statistics Specifies if document count, sum of document frequencies and sum of total term frequencies should be returned.
      # @option arguments [List] :fields A comma-separated list of fields to return.
      # @option arguments [Boolean] :offsets Specifies if term offsets should be returned.
      # @option arguments [Boolean] :positions Specifies if term positions should be returned.
      # @option arguments [Boolean] :payloads Specifies if term payloads should be returned.
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random).
      # @option arguments [String] :routing Specific routing value.
      # @option arguments [Boolean] :realtime Specifies if request is real-time as opposed to near-real-time (default: true).
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type
      #   (options: internal,external,external_gte,force)

      # @option arguments [Hash] :body Define parameters and or supply a document to get termvectors for. See documentation.
      #
      # *Deprecation notice*:
      # Specifying types in urls has been deprecated
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docs-termvectors.html
      #
      def termvectors(arguments = {})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone

        _index = arguments.delete(:index)

        _id = arguments.delete(:id)

        _type = arguments.delete(:type)

        method = Elasticsearch::API::HTTP_GET

        endpoint = arguments.delete(:endpoint) || '_termvectors'
        path = if _index && _type && _id
                 "#{Utils.__listify(_index)}/#{Utils.__listify(_type)}/#{Utils.__listify(_id)}/#{endpoint}"
               elsif _index && _type
                 "#{Utils.__listify(_index)}/#{Utils.__listify(_type)}/#{endpoint}"
               elsif _index && _id
                 "#{Utils.__listify(_index)}/#{endpoint}/#{Utils.__listify(_id)}"
               else
                 "#{Utils.__listify(_index)}/#{endpoint}"
  end

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        perform_request(method, path, params, body).body
      end

      # Deprecated: Use the plural version, {#termvectors}
      #
      def termvector(arguments = {})
        termvectors(arguments.merge endpoint: '_termvector')
      end
      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:termvectors, [
        :term_statistics,
        :field_statistics,
        :fields,
        :offsets,
        :positions,
        :payloads,
        :preference,
        :routing,
        :realtime,
        :version,
        :version_type
      ].freeze)
    end
    end
end

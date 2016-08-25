module Elasticsearch
  module API
    module Actions

      # Return names of queries matching a document.
      #
      # Percolator allows you to register queries and then evaluate a document against them:
      # the IDs of matching queries are returned in the response.
      #
      # @example Register queries named "alert-1" and "alert-2" for the "my-index" index
      #
      #     client.index index: 'my-index',
      #                  type: '.percolator',
      #                  id: 'alert-1',
      #                  body: { query: { query_string: { query: 'foo' } } }
      #
      #     client.index index: 'my-index',
      #                  type: '.percolator',
      #                  id: 'alert-2',
      #                  body: { query: { query_string: { query: 'bar' } } }
      #
      # @example Evaluate a custom document (passed as `:doc`) against the queries
      #
      #     client.percolate index: 'my-index', type: 'my-type', body: { doc: { title: "Foo" } }
      #     # => {..., matches: [ {_index: 'my-index', _id: 'alert-1'} ]}
      #
      #     client.percolate index: 'my-index', type: 'my-type', body: { doc: { title: "Foo Bar" } }
      #     # => {..., matches: [ {_index: 'my-index', _id: 'alert-2'}, {_index: 'my-index', _id: 'alert-1'} ] }
      #
      # @example Evaluate an existing document against the queries
      #
      #     client.index index: 'my-index', type: 'my-type', id: 123, body: { title: "Foo Bar" }
      #
      #     client.percolate index: 'my-index', type: 'my-type', id: '123'
      #     # => { ..., matches: [ {_index: 'my-index', _id: 'alert-2'}, { _index: 'my-index', _id: 'alert-1'} ] }
      #
      # @example Register a query with custom `priority` property
      #
      #     client.index index: 'my-index',
      #                  type: '.percolator',
      #                  id: 'alert-high-1',
      #                  body: { query: { query_string: { query: 'foo' } },
      #                          priority: 'high' }
      #
      # @example Evaluate a document against "high priority" percolator queries
      #
      #     client.percolate index: 'my-index', type: 'my-type', body: {
      #         doc:    { title: "Foo" },
      #         filter: { term: { priority: 'high' } }
      #       }
      #     # => {..., matches: [ {_index: 'my-index', _id: 'alert-high-1'} ]}
      #
      # @option arguments [String] :index The index of the document being percolated. (*Required*)
      # @option arguments [String] :type The type of the document being percolated. (*Required*)
      # @option arguments [String] :id Fetch the document specified by index/type/id and
      #                                use it instead of the passed `doc`
      # @option arguments [Hash] :body The percolator request definition using the percolate DSL
      # @option arguments [List] :routing A comma-separated list of specific routing values
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
      #                                                 unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
      #                                               no concrete indices. (This includes `_all` string or when no
      #                                               indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are
      #                                              open, closed or both. (options: open, closed)
      # @option arguments [String] :percolate_index The index to percolate the document into. Defaults to passed `index`.
      # @option arguments [String] :percolate_format Return an array of matching query IDs instead of objects.
      #                                              (options: ids)
      # @option arguments [String] :percolate_type The type to percolate document into. Defaults to passed `type`.
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-percolate.html
      #
      def percolate(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]

        valid_params = [
          :routing,
          :preference,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :percolate_index,
          :percolate_type,
          :percolate_format,
          :version,
          :version_type ]

        unsupported_params = [ :percolate_format ]
        Utils.__report_unsupported_parameters(arguments.keys, unsupported_params)

        method = HTTP_GET
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id]),
                                 '_percolate'

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end

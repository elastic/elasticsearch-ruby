module Elasticsearch
  module Extensions
    # Reindex using the scroll api. This moves data (not mappings) from one index
    # to another. The target index can be on a different cluster.
    #
    # This is useful when updating mappings on existing fields in an index (eg with
    # new analyzers).
    #
    # @example Reindex all documents under a new index name
    #
    # Elasticsearch::Extensions::Reindex.new client: client, src_index: 'foo', target_index: 'bar'
    #
    # @see https://www.elastic.co/guide/en/elasticsearch/guide/current/reindex.html
    #
    # @option arguments [Client] :client (*Required*)
    # @option arguments [String] :src_index (*Required*)
    # @option arguments [String] :target_index (*Required*)
    # @option arguments [Client] :target_client
    # @option arguments [Int] :chunk_size
    # @option arguments [String] :period period to ask es to keep scroll buffer open '5m'
    #
    class Reindex
      def initialize(opts = {})
        raise ArgumentError, "Required argument 'client' missing"  unless opts[:client]
        raise ArgumentError, "Required argument 'src_index' missing"  unless opts[:src_index]
        raise ArgumentError, "Required argument 'target_index' missing" unless opts[:target_index]

        valid_params = [
          :client,
          :src_index,
          :target_index,
          :target_client,
          :chunk_size,
          :period
        ]

        default_params = {
          chunk_size: 500,
          period: '5m'
        }

        opts.each { |k, v| raise ArgumentError unless valid_params.include?(k) }
        params = default_params.merge(opts)
        client = params[:client]
        target_client = params[:target_client] || client

        r = client.search(index: params[:src_index],
                          search_type: 'scan',
                          scroll: params[:period],
                          size: params[:chunk_size])

        while r = client.scroll(scroll_id: r['_scroll_id'], scroll: params[:period]) do
          docs = r['hits']['hits']
          break if docs.empty?
          body = docs.map do |doc|
            doc['_index'] = params[:target_index]
            doc['data'] = doc['_source']
            doc.delete('_score')
            doc.delete('_source')
            { index: doc }
          end
          target_client.bulk body: body
        end
      end
    end
  end
end

# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Abort a running benchmark
      #
      # @example
      #
      #     client.abort_benchmark name: 'my_benchmark'
      #
      # @option arguments [String] :name A benchmark name
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/search-benchmark.html
      #
      def abort_benchmark(arguments = {})
        method = HTTP_POST
        path   = "_bench/abort/#{arguments[:name]}"
        params = {}
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end

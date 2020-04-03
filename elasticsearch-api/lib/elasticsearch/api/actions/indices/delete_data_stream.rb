# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Deletes a data stream.
        #
        # @option arguments [String] :name The name of the data stream

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/data-streams.html
        #
        def delete_data_stream(arguments = {})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_data_stream/#{Utils.__listify(_name)}"
          params = {}

          body = nil
          perform_request(method, path, params, body).body
        end
end
      end
  end
end

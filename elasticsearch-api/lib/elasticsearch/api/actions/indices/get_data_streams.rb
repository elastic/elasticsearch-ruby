# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Returns data streams.
        #
        # @option arguments [List] :name The comma separated names of data streams

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/data-streams.html
        #
        def get_data_streams(arguments = {})
          arguments = arguments.clone

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_GET
          path   = if _name
                     "_data_streams/#{Utils.__listify(_name)}"
                   else
                     "_data_streams"
end
          params = {}

          body = nil
          perform_request(method, path, params, body).body
        end
end
      end
  end
end

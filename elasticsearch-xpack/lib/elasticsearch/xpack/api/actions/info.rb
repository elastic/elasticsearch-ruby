# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Actions

        # Retrieve information about xpack, including build number/timestamp and license status
        #
        # @option arguments [Boolean] :human Presents additional info for humans
        #                                   (feature descriptions and X-Pack tagline)
        # @option arguments [List] :categories Comma-separated list of info categories.
        #                                      (Options: build, license, features)
        #
        # @see https://www.elastic.co/guide/en/x-pack/current/info-api.html
        #
        def info(arguments={})
          valid_params = [
            :human,
            :categories ]

          method = Elasticsearch::API::HTTP_GET
          path   = "_xpack"
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end

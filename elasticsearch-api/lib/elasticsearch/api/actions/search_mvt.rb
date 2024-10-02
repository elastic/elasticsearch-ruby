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
#
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Actions
      # Searches a vector tile for geospatial values. Returns results as a binary Mapbox vector tile.
      # This functionality is Experimental and may be changed or removed
      # completely in a future release. Elastic will take a best effort approach
      # to fix any issues, but experimental features are not subject to the
      # support SLA of official GA features.
      #
      # @option arguments [List] :index Comma-separated list of data streams, indices, or aliases to search
      # @option arguments [String] :field Field containing geospatial data to return
      # @option arguments [Integer] :zoom Zoom level for the vector tile to search
      # @option arguments [Integer] :x X coordinate for the vector tile to search
      # @option arguments [Integer] :y Y coordinate for the vector tile to search
      # @option arguments [Boolean] :exact_bounds If false, the meta layer's feature is the bounding box of the tile. If true, the meta layer's feature is a bounding box resulting from a `geo_bounds` aggregation.
      # @option arguments [Integer] :extent Size, in pixels, of a side of the vector tile.
      # @option arguments [Integer] :grid_precision Additional zoom levels available through the aggs layer. Accepts 0-8.
      # @option arguments [String] :grid_type Determines the geometry type for features in the aggs layer. (options: grid, point, centroid)
      # @option arguments [Integer] :size Maximum number of features to return in the hits layer. Accepts 0-10000.
      # @option arguments [Boolean|long] :track_total_hits Indicate if the number of documents that match the query should be tracked. A number can also be specified, to accurately track the total hit count up to the number.
      # @option arguments [Boolean] :with_labels If true, the hits and aggs layers will contain additional point features with suggested label positions for the original features.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body Search request body.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/search-vector-tile-api.html
      #
      def search_mvt(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'search_mvt' }

        defined_params = %i[index field zoom x y].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'field' missing" unless arguments[:field]
        raise ArgumentError, "Required argument 'zoom' missing" unless arguments[:zoom]
        raise ArgumentError, "Required argument 'x' missing" unless arguments[:x]
        raise ArgumentError, "Required argument 'y' missing" unless arguments[:y]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body   = arguments.delete(:body)

        _index = arguments.delete(:index)

        _field = arguments.delete(:field)

        _zoom = arguments.delete(:zoom)

        _x = arguments.delete(:x)

        _y = arguments.delete(:y)

        method = Elasticsearch::API::HTTP_POST
        path   = "#{Utils.__listify(_index)}/_mvt/#{Utils.__listify(_field)}/#{Utils.__listify(_zoom)}/#{Utils.__listify(_x)}/#{Utils.__listify(_y)}"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end

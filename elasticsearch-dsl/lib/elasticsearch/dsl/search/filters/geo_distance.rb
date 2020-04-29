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

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns documents which fall into a specified geographical distance
        #
        # @example Define the filter with a hash
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_distance location: '50.090223,14.399590', distance: '5km'
        #           end
        #         end
        #       end
        #     end
        #
        # @example Define the filter with a block
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geo_distance :location do
        #               lat '50.090223'
        #               lon '14.399590'
        #               distance '5km'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/guide/current/geo-distance.html
        #
        class GeoDistance
          include BaseComponent

          option_method :distance,      lambda { |*args| @hash[self.name.to_sym].update distance: args.pop }
          option_method :distance_type, lambda { |*args| @hash[self.name.to_sym].update distance_type: args.pop }
          option_method :lat,           lambda { |*args| @hash[self.name.to_sym][@args].update lat: args.pop }
          option_method :lon,           lambda { |*args| @hash[self.name.to_sym][@args].update lon: args.pop }

          def initialize(*args, &block)
            super
            @hash[self.name.to_sym] = { @args => {} } unless @args.empty?
          end
        end

      end
    end
  end
end

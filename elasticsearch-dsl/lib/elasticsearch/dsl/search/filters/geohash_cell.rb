# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

        # A filter which translates lat/lon values into a geohash with the specified precision
        # and returns all documents which fall into it
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             geohash_cell :location do
        #               lat '50.090223'
        #               lon '14.399590'
        #               precision '5km'
        #               neighbors true
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/guide/current/geohash-cell-filter.html
        #
        class GeohashCell
          include BaseComponent

          option_method :precision, lambda { |*args| @hash[self.name.to_sym].update precision: args.pop }
          option_method :lat,       lambda { |*args| @hash[self.name.to_sym][@args].update lat: args.pop }
          option_method :lon,       lambda { |*args| @hash[self.name.to_sym][@args].update lon: args.pop }
          option_method :neighbors, lambda { |*args| @hash[self.name.to_sym].update neighbors: args.pop }

          def initialize(*args, &block)
            super
            @hash[self.name.to_sym] = { @args => {} } unless @args.empty?
          end
        end
      end
    end
  end
end

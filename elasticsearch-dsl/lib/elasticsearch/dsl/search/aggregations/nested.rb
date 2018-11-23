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
      module Aggregations

        # A single-bucket aggregation which allows to aggregate on nested fields
        #
        # @example
        #
        #    search do
        #      aggregation :offers do
        #        nested do
        #          path 'offers'
        #          aggregation :min_price do
        #            min field: 'offers.price'
        #          end
        #        end
        #      end
        #    end
        #
        # See the integration test for a full example.
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-bucket-nested-aggregation.html
        #
        class Nested
          include BaseAggregationComponent

          option_method :path
        end

      end
    end
  end
end

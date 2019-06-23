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
      module Queries

        # A query which returns documents which are similar to the specified text
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy_like_this do
        #           like_text 'Eyjafjallajökull'
        #           fields [:title, :abstract, :content]
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-flt-query.html
        #
        class FuzzyLikeThis
          include BaseComponent

          option_method :fields
          option_method :like_text
          option_method :fuzziness
          option_method :analyzer
          option_method :max_query_terms
          option_method :prefix_length
          option_method :boost
          option_method :ignore_tf
        end

      end
    end
  end
end

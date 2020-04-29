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
      module Queries

        # A query which uses a Levenshtein distance on string fields and plus-minus margin on numerical
        # fields to match documents
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy :name do
        #           value 'Eyjafjallajökull'
        #         end
        #       end
        #     end
        #
        # @example
        #
        #     search do
        #       query do
        #         fuzzy :published_on do
        #           value '2014-01-01'
        #           fuzziness '7d'
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html
        #
        class Fuzzy
          include BaseComponent

          option_method :value
          option_method :boost
          option_method :fuzziness
          option_method :prefix_length
          option_method :max_expansions
        end

      end
    end
  end
end

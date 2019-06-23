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

        # A query which returns documents matching a wildcard expression
        #
        # @note The expression is *not analyzed* (lowercased, stemmed, etc)
        #
        # @example
        #
        #     search do
        #       query do
        #        wildcard title: 'tw*'
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-wildcard-query.html
        #
        class Wildcard
          include BaseComponent

          option_method :value
          option_method :boost
        end

      end
    end
  end
end

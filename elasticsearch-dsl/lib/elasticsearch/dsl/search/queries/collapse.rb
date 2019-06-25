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

      class Collapse
        include BaseComponent

        def initialize(field, &block)
          @value = { field: field }
          super
        end

        def inner_hits(name=nil, &block)
          if name
            @inner_hits = InnerHits.new(name, &block)
            self
          else
            @inner_hits
          end
        end

        def max_concurrent_group_searches(max)
          @value[:max_concurrent_group_searches] = max
        end

        def to_hash
          call
          @hash = @value
          @hash[:inner_hits] = @inner_hits.to_hash if @inner_hits
          @hash
        end
      end
    end
  end
end

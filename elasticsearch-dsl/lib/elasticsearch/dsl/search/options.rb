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

      # Wraps the "extra" options of a search definition
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-body.html
      #
      class Options
        DSL_METHODS = [
          :_source,
          :fields,
          :script_fields,
          :fielddata_fields,
          :rescore,
          :explain,
          :version,
          :indices_boost,
          :track_scores,
          :min_score
        ]

        def initialize(*args, &block)
          @hash = {}
        end

        # Defines a method for each valid search definition option
        #
        DSL_METHODS.each do |name|
          define_method name do |*args, &block|
            @hash[name] = args.pop
          end

          define_method name.to_s.gsub(/^_(.*)/, '\1') do |*args, &block|
            @hash[name] = args.pop
          end
        end

        # Returns true when there are no search options defined
        #
        def empty?
          @hash.empty?
        end

        # Convert the definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash(options={})
          @hash
        end
      end
    end
  end
end

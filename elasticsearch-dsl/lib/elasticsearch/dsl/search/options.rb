module Elasticsearch
  module DSL
    module Search

      # Wraps the "extra" options of a search definition
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-body.html
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
          super
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

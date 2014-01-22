module Elasticsearch
  module API
    module Indices
      module Actions

        # TODO: Description
        #
        # @option arguments [String] :name The name of the template (*Required*)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/indices-templates.html
        #
        def exists_template(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          valid_params = [ :local ]

          method = 'HEAD'
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, valid_params
          body = nil

          perform_request(method, path, params, body).status == 200 ? true : false
        rescue Exception => e
          if e.class.to_s =~ /NotFound/ || e.message =~ /Not\s*Found|404/i
            false
          else
            raise e
          end
        end
      end
    end
  end
end

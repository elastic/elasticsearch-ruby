# frozen_string_literal: true

# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    # Handles specific exceptional parameters and code snippets that need to be
    # included in the generated code. This module is included in SourceGenerator
    # so its methods can be used from the ERB template (method.erb). This will
    # potentially be refactored into different templates.
    module EndpointSpecifics
      # Endpoints that need Utils.__rescue_from_not_found
      IGNORE_404 = %w[
        exists
        indices.exists
        indices.exists_alias
        indices.exists_template
        indices.exists_type
      ].freeze

      # Endpoints that need Utils.__rescue_from_not_found if the ignore
      # parameter is included
      COMPLEX_IGNORE_404 = %w[
        delete
        get
        indices.flush_synced
        indices.delete_template
        indices.delete
        snapshot.status
        snapshot.get
        snapshot.get_repository
        snapshot.delete_repository
        snapshot.delete
        update
      ].freeze

      # Endpoints that need params[:h] listified
      H_PARAMS = %w[aliases allocation count health indices nodes pending_tasks
                    recovery shards thread_pool].freeze

      def specific_params(namespace)
        params = []
        if H_PARAMS.include?(@method_name) && namespace == 'cat'
          params << 'params[:h] = Utils.__listify(params[:h]) if params[:h]'
        end
        params
      end

      def needs_ignore_404?(endpoint)
        IGNORE_404.include? endpoint
      end

      def needs_complex_ignore_404?(endpoint)
        COMPLEX_IGNORE_404.include? endpoint
      end

      def termvectors_path
        <<~SRC
          if _index && _type && _id
            "\#{Utils.__listify(_index)}/\#{Utils.__listify(_type)}/\#{Utils.__listify(_id)}/\#{endpoint}"
          elsif _index && _type
            "\#{Utils.__listify(_index)}/\#{Utils.__listify(_type)}/\#{endpoint}"
          elsif _index && _id
            "\#{Utils.__listify(_index)}/\#{endpoint}/\#{Utils.__listify(_id)}"
          else
            "\#{Utils.__listify(_index)}/\#{endpoint}"
          end
        SRC
      end

      def ping_perform_request
        <<~SRC
          begin
            perform_request(method, path, params, body).status == 200 ? true : false
          rescue Exception => e
            if e.class.to_s =~ /NotFound|ConnectionFailed/ || e.message =~ /Not\s*Found|404|ConnectionFailed/i
              false
            else
              raise e
            end
          end
        SRC
      end
    end
  end
end

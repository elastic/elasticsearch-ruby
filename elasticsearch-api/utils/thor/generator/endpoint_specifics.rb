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
        security.get_role
        security.get_user
        snapshot.status
        snapshot.get
        snapshot.get_repository
        snapshot.delete_repository
        snapshot.delete
        update
        watcher.delete_watch
      ].freeze

      # Endpoints that need params[:h] listified
      H_PARAMS = %w[aliases allocation count health indices nodes pending_tasks
                    recovery shards thread_pool].freeze

      # Function that adds the listified h param code
      def specific_params(namespace)
        params = []
        if H_PARAMS.include?(@method_name) && namespace == 'cat'
          if @method_name == 'nodes'
            params << 'params[:h] = Utils.__listify(params[:h], escape: false) if params[:h]'
          else
            params << 'params[:h] = Utils.__listify(params[:h]) if params[:h]'
          end
        end
        params
      end

      def needs_ignore_404?(endpoint)
        IGNORE_404.include? endpoint
      end

      def needs_complex_ignore_404?(endpoint)
        COMPLEX_IGNORE_404.include? endpoint
      end

      def module_name_helper(name)
        return name.upcase if %w[sql ssl].include? name

        name.split('_').map(&:capitalize).join
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
            perform_request(method, path, params, body, headers).status == 200 ? true : false
          rescue Exception => e
            if e.class.to_s =~ /NotFound|ConnectionFailed/ || e.message =~ /Not\s*Found|404|ConnectionFailed/i
              false
            else
              raise e
            end
          end
        SRC
      end

      def indices_stats_params_registry
        <<~SRC
          ParamsRegistry.register(:stats_params, [
            #{@spec['params'].keys.map { |k| ":#{k}" }.join(",\n")}
          ].freeze)

          ParamsRegistry.register(:stats_parts, [
            #{@parts['metric']['options'].push('metric').map { |k| ":#{k}" }.join(",\n")}
          ].freeze)
        SRC
      end

      def msearch_body_helper
        <<~SRC
          case
          when body.is_a?(Array) && body.any? { |d| d.has_key? :search }
            payload = body.
              inject([]) do |sum, item|
                meta = item
                data = meta.delete(:search)

                sum << meta
                sum << data
                sum
              end.
              map { |item| Elasticsearch::API.serializer.dump(item) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          when body.is_a?(Array)
            payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          else
            payload = body
          end
        SRC
      end

      def msearch_template_body_helper
        <<~SRC
          case
          when body.is_a?(Array)
            payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          else
            payload = body
          end
        SRC
      end

      def bulk_body_helper
        <<~SRC
          if body.is_a? Array
            payload = Elasticsearch::API::Utils.__bulkify(body)
          else
            payload = body
          end
        SRC
      end

      def bulk_doc_helper(info)
        <<~SRC
          # @option arguments [String|Array] :body #{info}. Array of Strings, Header/Data pairs,
          # or the conveniency "combined" format can be passed, refer to Elasticsearch::API::Utils.__bulkify documentation.
        SRC
      end
    end
  end
end

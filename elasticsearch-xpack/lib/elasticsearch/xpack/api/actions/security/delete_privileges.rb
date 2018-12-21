module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # @option arguments [String] :application Application name (*Required*)
          # @option arguments [Boolean] :name Privilege name (*Required*)
          #
          def delete_privileges(arguments={})
            raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
            raise ArgumentError, "Required argument 'application' missing" unless arguments[:application]

            valid_params = [ :refresh ]

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/security/privilege/#{arguments.delete(:application)}/#{arguments[:name]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end

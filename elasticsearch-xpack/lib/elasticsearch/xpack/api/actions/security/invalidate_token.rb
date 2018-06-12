module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Delete a token for OAuth 2.0 auhentication
          #
          # @option arguments [Hash] :body The token to invalidate (*Required*)
          #
          # @see https://www.elastic.co/guide/en/x-pack/master/security-api-tokens.html#security-api-invalidate-token
          #
          def invalidate_token(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/security/oauth2/token"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end

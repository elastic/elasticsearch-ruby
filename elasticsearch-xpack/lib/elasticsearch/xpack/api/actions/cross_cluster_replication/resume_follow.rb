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
  module XPack
    module API
      module CrossClusterReplication
        module Actions
          # Resumes a follower index that has been paused
          #
          # @option arguments [String] :index The name of the follow index to resume following.
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The name of the leader index and other optional ccr related parameters
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/ccr-post-resume-follow.html
          #
          def resume_follow(arguments = {})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _index = arguments.delete(:index)

            method = Elasticsearch::API::HTTP_POST
            path   = "#{Elasticsearch::API::Utils.__listify(_index)}/_ccr/resume_follow"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
        end
      end
    end
  end
end

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
    module Actions
      # Returns whether the cluster is running.
      #
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.9/index.html
      #
      def ping(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        method = Elasticsearch::API::HTTP_HEAD
        path   = ""
        params = {}

        body = nil
        begin
        perform_request(method, path, params, body, headers).status == 200 ? true : false
        rescue Exception => e
          if e.class.to_s =~ /NotFound|ConnectionFailed/ || e.message =~ /Not *Found|404|ConnectionFailed/i
            false
          else
            raise e
          end
      end
      end
    end
  end
end

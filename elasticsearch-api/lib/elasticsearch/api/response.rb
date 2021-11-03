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
    # Elasticsearch client API Response object. Receives an Elastic::Transport::Transport::Response in
    # the initializer and behaves like a Hash, except when status or headers are called upon it, in
    # which case it returns the original object's status and headers.
    class Response
      RESPONSE_METHODS = [:status, :body, :headers]

      def initialize(response)
        @response = response
      end

      def method_missing(method, *args, &block)
        if RESPONSE_METHODS.include? method
          @response.send method.to_sym
        else
          @response.body.send(method.to_sym, *args, &block)
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @response.body.respond_to?(method_name, include_private) ||
          RESPONSE_METHODS.include?(method_name)
      end

      def to_s
        @response.body.to_s
      end
    end
  end
end

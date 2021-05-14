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
    module Eql
      module Actions; end

      # Client for the "eql" namespace (includes the {Eql::Actions} methods)
      #
      class EqlClient
        include Common::Client, Common::Client::Base, Eql::Actions
      end

      # Proxy method for {EqlClient}, available in the receiving object
      #
      def eql
        @eql ||= EqlClient.new(self)
      end
    end
  end
end

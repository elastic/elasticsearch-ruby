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
    module MachineLearning
      module Actions; end

      # Client for the "machine_learning" namespace (includes the {MachineLearning::Actions} methods)
      #
      class MachineLearningClient
        include Common::Client, Common::Client::Base, MachineLearning::Actions
      end

      # Proxy method for {MachineLearningClient}, available in the receiving object
      #
      def machine_learning
        @machine_learning ||= MachineLearningClient.new(self)
      end

      alias ml machine_learning
    end
  end
end

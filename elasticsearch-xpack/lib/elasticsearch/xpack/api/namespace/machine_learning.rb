# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions; end

        class MachineLearningClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, MachineLearning::Actions
        end

        def machine_learning
          @machine_learning ||= MachineLearningClient.new(self)
        end

        alias :ml :machine_learning

      end
    end
  end
end

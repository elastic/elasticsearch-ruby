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
#
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Set upgrade_mode for ML indices.
        # Sets a cluster wide upgrade_mode setting that prepares machine learning
        # indices for an upgrade.
        # When upgrading your cluster, in some circumstances you must restart your
        # nodes and reindex your machine learning indices. In those circumstances,
        # there must be no machine learning jobs running. You can close the machine
        # learning jobs, do the upgrade, then open all the jobs again. Alternatively,
        # you can use this API to temporarily halt tasks associated with the jobs and
        # datafeeds and prevent new jobs from opening. You can also use this API
        # during upgrades that do not require you to reindex your machine learning
        # indices, though stopping jobs is not a requirement in that case.
        # You can see the current value for the upgrade_mode setting by using the get
        # machine learning info API.
        #
        # @option arguments [Boolean] :enabled When +true+, it enables +upgrade_mode+ which temporarily halts all job
        #  and datafeed tasks and prohibits new job and datafeed tasks from
        #  starting.
        # @option arguments [Time] :timeout The time to wait for the request to be completed. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-set-upgrade-mode
        #
        def set_upgrade_mode(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.set_upgrade_mode' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_ml/set_upgrade_mode'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

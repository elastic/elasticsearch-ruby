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
        # Get machine learning information.
        # Get defaults and limits used by machine learning.
        # This endpoint is designed to be used by a user interface that needs to fully
        # understand machine learning configurations where some options are not
        # specified, meaning that the defaults should be used. This endpoint may be
        # used to find out what those defaults are. It also provides information about
        # the maximum size of machine learning jobs that could run in the current
        # cluster configuration.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-info
        #
        def info(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.info' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_ml/info'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

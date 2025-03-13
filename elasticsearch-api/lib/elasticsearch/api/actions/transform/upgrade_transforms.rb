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
    module Transform
      module Actions
        # Upgrade all transforms.
        # Transforms are compatible across minor versions and between supported major versions.
        # However, over time, the format of transform configuration information may change.
        # This API identifies transforms that have a legacy configuration format and upgrades them to the latest version.
        # It also cleans up the internal data structures that store the transform state and checkpoints.
        # The upgrade does not affect the source and destination indices.
        # The upgrade also does not affect the roles that transforms use when Elasticsearch security features are enabled; the role used to read source data and write to the destination index remains unchanged.
        # If a transform upgrade step fails, the upgrade stops and an error is returned about the underlying issue.
        # Resolve the issue then re-run the process again.
        # A summary is returned when the upgrade is finished.
        # To ensure continuous transforms remain running during a major version upgrade of the cluster – for example, from 7.16 to 8.0 – it is recommended to upgrade transforms before upgrading the cluster.
        # You may want to perform a recent cluster backup prior to the upgrade.
        #
        # @option arguments [Boolean] :dry_run When true, the request checks for updates but does not run them.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and
        #  returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-upgrade-transforms
        #
        def upgrade_transforms(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.upgrade_transforms' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_transform/_upgrade'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

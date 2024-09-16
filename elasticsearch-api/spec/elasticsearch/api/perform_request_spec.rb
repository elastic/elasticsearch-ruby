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

require 'spec_helper'
require 'elastic-transport'
require_relative '../../../utils/thor/endpoint_spec'
require_relative '../../../utils/thor/generator/files_helper'

describe 'Perform request args' do
  Elasticsearch::API::FilesHelper.files.each do |filepath|
    spec = Elasticsearch::API::EndpointSpec.new(filepath)
    next if spec.module_namespace.flatten.first == '_internal' || spec.visibility != 'public'

    # These are the path parts defined by the user in the method argument
    defined_path_parts = spec.path_params.inject({}) do |params, part|
      params.merge(part => 'testing')
    end

    # These are the required params, we must pass them to the method even when testing
    required_params = spec.required_parts.inject({}) do |params, part|
      params.merge(part.to_sym => 'testing')
    end

    let(:client_double) do
      Class.new { include Elasticsearch::API }.new.tap do |client|
        expect(client).to receive(:perform_request) do |_, _, _, _, _, request_params|
          # The create method ends up becoming an 'index' request
          if expected_perform_request_params[:endpoint] == 'create'
            expected_perform_request_params[:endpoint] = 'index'
          end
          # Check that the expected hash is passed to the perform_request method
          expect(request_params).to eq(expected_perform_request_params)
        end.and_return(response_double)
      end
    end

    let(:response_double) do
      double('response', status: 200, body: {}, headers: {})
    end

    context("'#{spec.endpoint_name}'") do
      # The expected hash passed to perform_request contains the endpoint name and any defined path parts
      let(:expected_perform_request_params) do
        if defined_path_parts.empty?
          { endpoint: spec.endpoint_name }
        else
          { endpoint: spec.endpoint_name, defined_params: defined_path_parts }
        end
      end

      if spec.path_parts.empty?
        it "passes the endpoint id to the request" do
          if spec.module_namespace.empty?
            client_double.send(spec.method_name, required_params)
          else
            client_double.send(spec.module_namespace[0]).send(spec.method_name, required_params)
          end
        end
      else
        it "passes params to the request with the endpoint id: #{spec.path_parts.keys}" do
          if spec.module_namespace.empty?
            client_double.send(spec.method_name, required_params.merge(defined_path_parts))
          else
            client_double.send(
              spec.module_namespace[0]).send(spec.method_name, required_params.merge(defined_path_parts)
            )
          end
        end
      end
    end
  end
end

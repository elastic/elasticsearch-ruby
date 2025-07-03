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

require 'elastic-transport'
require 'spec_helper'

# Helper Class to replace the EndpointSpec class from the old code generator. The created object
# will store some relevant data to the endpoint specification so that it can be used to test
# OpenTelemetry.
class EndpointSpec
  attr_reader :module_namespace,
              :method_name,
              :endpoint_name,
              :visibility

  def initialize(filepath)
    @path = Pathname(filepath)
    json = MultiJson.load(File.read(@path))
    @endpoint_name = json.keys.first

    full_namespace = parse_full_namespace
    @namespace_depth = full_namespace.size.positive? ? full_namespace.size - 1 : 0
    @module_namespace = full_namespace[0, @namespace_depth]
    @visivility = json.values.first['visibility']
  end

  def parse_full_namespace
    names = @endpoint_name.split('.')
    # Return an array to expand 'ccr', 'ilm', 'ml' and 'slm'
    names.map do |name|
      name
        .gsub(/^ml$/, 'machine_learning')
        .gsub(/^ilm$/, 'index_lifecycle_management')
        .gsub(/^ccr/, 'cross_cluster_replication')
        .gsub(/^slm/, 'snapshot_lifecycle_management')
    end
  end
end

# JSON spec files to test
# This is a helper which used to be in the FilesHelper module in the old code generator. It goes
# through the files in the Elasticsearch JSON specification to see which methods need to be tested
# and how.
def files
  src_path = File.expand_path('../../../tmp/rest-api-spec/api/', __dir__)

  Dir.entries(src_path).reject do |file|
    File.extname(file) != '.json' ||
      File.basename(file) == '_common.json'
  end.map { |file| "#{src_path}/#{file}" }
end

describe 'Perform request args' do
  files.each do |filepath|
    spec = EndpointSpec.new(filepath)
    next if spec.module_namespace.flatten.first == '_internal' ||
            spec.visibility != 'public' ||
            # TODO: Once the test suite is migrated to elasticsearch-specification, these should be removed
            spec.module_namespace.flatten.first == 'rollup' ||
            [
              'scroll', 'clear_scroll', 'connector.last_sync', 'knn_search'
            ].include?(spec.endpoint_name)

    # Skip testing if the method hasn't been added to the client yet:
    client = Elasticsearch::Client.new
    implemented = if spec.module_namespace.empty?
                    client.public_methods.include?(spec.method_name.to_sym)
                  else
                    client.public_methods.include?(spec.module_namespace[0].to_sym) &&
                      client.send(spec.module_namespace[0]).methods.include?(spec.method_name.to_sym)
                  end
    unless implemented
      name = spec.module_namespace.empty? ? spec.method_name : "#{spec.module_namespace[0]}.#{spec.method_name}"
      Logger.new($stdout).info("Method #{name} not implemented yet")
      next
    end

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
        it 'passes the endpoint id to the request' do
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
              spec.module_namespace[0]
            ).send(
              spec.method_name, required_params.merge(defined_path_parts)
            )
          end
        end
      end
    end
  end
end

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
require 'opentelemetry-sdk'

include Elasticsearch::API::EndpointSpecifics

def __full_namespace
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

def __endpoint_parts
  parts = @spec['url']['paths'].select do |a|
    a.keys.include?('parts')
  end.map do |path|
    path&.[]('parts')
  end
  (parts.inject(&:merge) || [])
end

def __http_method
  return '_id ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST' if @endpoint_name == 'index'
  return '_name ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST' if @method_name == 'create_service_token'
  return post_and_get if @endpoint_name == 'count'

  default_method = @spec['url']['paths'].map { |a| a['methods'] }.flatten.first
  if @spec['body'] && default_method == 'GET'
    # When default method is GET and body is required, we should always use POST
    if @spec['body']['required']
      'Elasticsearch::API::HTTP_POST'
    else
      post_and_get
    end
  else
    "Elasticsearch::API::HTTP_#{default_method}"
  end
end

def __required_parts
  required = []
  return required if @endpoint_name == 'tasks.get'

  required << 'body' if (@spec['body'] && @spec['body']['required'])
  # Get required variables from paths:
  req_variables = __path_variables.inject(:&) # find intersection
  required << req_variables unless req_variables.empty?
  required.flatten
end

def __path_variables
  @paths.map do |path|
    __extract_path_variables(path)
  end
end

# extract values that are in the {var} format:
def __extract_path_variables(path)
  path.scan(/{(\w+)}/).flatten
end

def post_and_get
  # the METHOD is defined after doing arguments.delete(:body), so we need to check for `body`
  <<~SRC
    if body
      Elasticsearch::API::HTTP_POST
    else
      Elasticsearch::API::HTTP_GET
    end
  SRC
end

describe 'OpenTelemetry' do

   Elasticsearch::API::FilesHelper.files.each do |filepath|
   #filepath = Elasticsearch::API::FilesHelper.files[1]
     @path = Pathname(filepath)
     @json = MultiJson.load(File.read(@path))
     @spec = @json.values.first

     @spec['url'] ||= {}

     @endpoint_name    = @json.keys.first
     @full_namespace   = __full_namespace
     @namespace_depth  = @full_namespace.size > 0 ? @full_namespace.size - 1 : 0
     @module_namespace = @full_namespace[0, @namespace_depth]

     # Don't generate code for internal APIs:
     next if @module_namespace.flatten.first == '_internal'

     @method_name      = @full_namespace.last
     @parts            = __endpoint_parts
     @params           = @spec['params'] || {}
     @specific_params  = specific_params(@module_namespace.first) # See EndpointSpecifics
     @paths            = @spec['url']['paths'].map { |b| b['path'] }
     @required_parts   = __required_parts

     @example_paths = @paths.collect { |path| path.gsub(/\{[^\/]+\}/, 'testing')}

     defined_params = @parts.inject({}) do |args, part|
       args[part[0].to_sym] = 'testing'
       args
     end

     args = @required_parts.inject({}) do |arguments, required_part|
       arguments[required_part.to_sym] = 'testing'
       arguments
     end

     namespace = @module_namespace
     method_name = @method_name
     endpoint_name = @endpoint_name
     parts = @parts

     # check request_opts
     # {:endpoint=>"indices.refresh", :defined_params=>{"index"=>"testing"}}

     let(:client_double) do
       Class.new { include Elasticsearch::API }.new.tap do |client|
         expect(client).to receive(:perform_request) do |_, _, _, _, _, request_params|
           expect(request_params).to eq(expected_params)
         end
       end
     end

     let(:response_double) do
       double('response', status: 200, body: {}, headers: {})
     end
     context(@endpoint_name) do

       let(:expected_params) do
         params = {endpoint: endpoint_name}
         params[:defined_params] = defined_params unless defined_params.empty?
         params
       end

       if parts.empty?
         it("passes the endpoint id to the request") do
           unless namespace.empty?
             client_double.send(namespace[0]).send(method_name, args.merge(defined_params))
           else
             client_double.send(method_name, defined_params)
           end
         end
       else
         it("passes the right params to the request: #{parts.keys}") do
           unless namespace.empty?
             client_double.send(namespace[0]).send(method_name, args.merge(defined_params))
           else
             client_double.send(method_name, args.merge(defined_params))
           end
         end
       end
     end
   end
end
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

describe Elasticsearch::Client do
  context 'when using custom transport implementation' do
    class MyTransport
      include Elastic::Transport::Transport::Base
      def initialize(args); end
    end
    let(:client) { Elasticsearch::Client.new(transport_class: MyTransport) }
    let(:arguments) { client.instance_variable_get('@transport').instance_variable_get('@arguments') }
    let(:subject) do
      arguments[:transport_options][:headers]
    end

    let(:meta_header) do
      if jruby?
        "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elastic::Transport::VERSION},jv=#{ENV_JAVA['java.version']},jr=#{JRUBY_VERSION}"
      else
        "es=#{meta_version},rb=#{RUBY_VERSION},t=#{Elastic::Transport::VERSION}"
      end
    end

    it 'doesnae set any info about the implementation in the metaheader' do
      expect(subject).to include('x-elastic-client-meta' => meta_header)
    end
  end
end

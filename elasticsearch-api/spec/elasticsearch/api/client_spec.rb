# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'API Client' do

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  describe '#cluster' do

    it 'responds to the method' do
      expect(client.respond_to?(:cluster)).to be(true)
    end
  end

  describe '#indices' do

    it 'responds to the method' do
      expect(client.respond_to?(:indices)).to be(true)
    end
  end

  describe '#bulk' do

    it 'responds to the method' do
      expect(client.respond_to?(:bulk)).to be(true)
    end
  end
end

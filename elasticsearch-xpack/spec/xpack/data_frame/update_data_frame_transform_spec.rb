# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#update_data_frame_transform' do

  let(:expected_args) do
    [
        'POST',
        '_data_frame/transforms/foo/_update',
        params,
        {},
        nil
    ]
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.data_frame.
        update_data_frame_transform(transform_id: 'foo', body: {})).to eq({})
  end

  context 'when body is not provided' do

    let(:client) do
      Class.new { include Elasticsearch::XPack::API }.new
    end

    it 'raises an exception' do
      expect {
        client.data_frame.update_data_frame_transform(transform_id: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when a transform_id is not provided' do

    let(:client) do
      Class.new { include Elasticsearch::XPack::API }.new
    end

    it 'raises an exception' do
      expect {
        client.data_frame.update_data_frame_transform(body: {})
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when params are specified' do

    let(:params) do
      { defer_validation: true }
    end

    it 'performs the request' do
      expect(client_double.data_frame.
          update_data_frame_transform(transform_id: 'foo', body: {}, defer_validation: true)).to eq({})
    end
  end
end

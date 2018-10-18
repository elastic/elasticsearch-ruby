require 'spec_helper'

describe 'client.cluster#state' do

  let(:expected_args) do
    [
        'GET',
        '_cluster/state',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cluster.state).to eq({})
  end

  context 'when a metric is specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/state/foo,bar',
          {},
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.state(metric: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when index templates are specified' do

    let(:expected_args) do
      [
          'GET',
          '_cluster/state',
          { index_templates: 'foo,bar' },
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cluster.state(index_templates: ['foo', 'bar'])).to eq({})
    end
  end
end

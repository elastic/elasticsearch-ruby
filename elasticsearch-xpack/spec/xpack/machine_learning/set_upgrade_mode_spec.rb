# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#set_upgrade_mode' do

  let(:expected_args) do
    [
       'POST',
       '_ml/set_upgrade_mode',
       {},
       nil,
       {}
    ]
  end

  it 'performs the request' do
    expect(client_double.ml.set_upgrade_mode).to eq({})
  end

  context 'when params are specified' do

    let(:expected_args) do
      [
        'POST',
        '_ml/set_upgrade_mode',
        { enabled: true, timeout: '10m' },
        nil,
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.ml.set_upgrade_mode(enabled: true, timeout: '10m')).to eq({})
    end
  end
end

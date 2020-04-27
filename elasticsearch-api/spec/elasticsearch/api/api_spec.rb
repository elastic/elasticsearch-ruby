# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::API do

  describe '#settings' do

    it 'allows access to settings' do
      expect(described_class.settings).not_to be_nil
    end

    it 'has a default serializer' do
      expect(Elasticsearch::API.serializer).to eq(MultiJson)
    end

    context 'when settings are changed' do

      before do
        Elasticsearch::API.settings[:foo] = 'bar'
      end

      it 'changes the settings' do
        expect(Elasticsearch::API.settings[:foo]).to eq('bar')
      end
    end
  end
end

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

describe Elasticsearch::DSL::Search::Aggregations::Composite do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(composite: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#size' do

      before do
        search.size(2_000)
      end

      it 'applies the option' do
        expect(search.to_hash[:composite][:foo][:size]).to eq(2_000)
      end
    end

    describe '#sources' do

      before do
        search.sources('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:composite][:foo][:sources]).to eq('bar')
      end
    end

    describe '#after' do
      context 'when after is not given' do
        before do
          search.size(2_000)
        end

        it 'applies the option' do
          expect(search.to_hash[:composite][:foo].keys).not_to include(:after)
        end
      end

      context 'when after is given' do
        before do
          search.after('fake_after_key')
        end

        it 'applies the option' do
          expect(search.to_hash[:composite][:foo][:after]).to eq('fake_after_key')
        end
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new(:foo) do
          size 2_000
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq({ composite: { foo: { size: 2_000 } } })
      end
    end
  end
end

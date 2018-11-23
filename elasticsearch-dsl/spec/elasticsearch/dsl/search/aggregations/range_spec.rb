# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::Range do

  let(:search) do
    described_class.new
  end

  context '#initialize' do

    let(:search) do
      described_class.new(field: 'test', ranges: [ { to: 50 } ])
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(range: { field: "test", ranges: [ {to: 50} ] })
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#field' do

      before do
        search.field('foo')
      end

      it 'applies the option' do
        expect(search.to_hash[:range][:foo][:field]).to eq('foo')
      end
    end

    describe '#script' do

      before do
        search.script('bar*2')
      end

      it 'applies the option' do
        expect(search.to_hash[:range][:foo][:script]).to eq('bar*2')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      context 'when keyed ranges are provided' do

        let(:search) do
          described_class.new(field: 'test') do
            key 'foo', to: 10
            key 'bar', from: 10, to: 20
          end
        end

        it 'sets the values' do
          expect(search.to_hash).to eq(range: { field: "test", keyed: true,
                                                ranges: [ {to: 10, key: 'foo'}, { from: 10, to: 20, key: 'bar'}]})
        end
      end

      context 'when keyed is set to false explicitly' do

        let(:search) do
          described_class.new do
            keyed false
            field 'test'
            key   'foo', to: 10
            key   'bar', from: 10, to: 20
          end
        end

        it 'sets the value' do
          expect(search.to_hash).to eq(range: { field: "test", keyed: false,
                                                ranges: [ {to: 10, key: 'foo'}, { from: 10, to: 20, key: 'bar'}]})
        end
      end

      context 'when field is defined' do

        let(:search) do
          described_class.new do
            field 'test'
            key   'foo', to: 10
            key   'bar', from: 10, to: 20
          end
        end

        it 'sets the value' do
          expect(search.to_hash).to eq(range: { field: "test", keyed: true,
                                                ranges: [ {to: 10, key: 'foo'}, { from: 10, to: 20, key: 'bar'}]})
        end
      end
    end
  end
end

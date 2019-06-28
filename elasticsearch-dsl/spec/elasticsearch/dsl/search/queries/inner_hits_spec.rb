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

describe Elasticsearch::DSL::Search::Queries::InnerHits do

  describe '#to_hash' do

    let(:search) do
      described_class.new :last_tweet do
        size 10
        from 5
        sort do
          by :date, order: 'desc'
          by :likes, order: 'asc'
        end
      end
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(name: :last_tweet,
                                   size: 10,
                                   from: 5,
                                   sort: [{ date: { order: 'desc' } },
                                          { likes: { order: 'asc' } }])
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#size' do

      before do
        search.size(10)
      end

      it 'applies the option' do
        expect(search.to_hash[:size]).to eq(10)
      end
    end

    describe '#from' do

      before do
        search.from(5)
      end

      it 'applies the option' do
        expect(search.to_hash[:from]).to eq(5)
      end
    end

    describe '#sort' do

      before do
        search.sort do
          by :date, order: 'desc'
          by :likes, order: 'asc'
        end
      end

      it 'applies the sort' do
        expect(search.to_hash).to eq(sort: [{ date: { order: 'desc' } },
                                            { likes: { order: 'asc' } }])
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      context 'when a name is specified' do

        let(:search) do
          described_class.new(:last_tweet) do
            size 5
          end
        end

        it 'defines the search clause' do
          expect(search.to_hash).to eq(name: :last_tweet, size: 5)
        end
      end

      context 'when a name is not specified' do

        let(:search) do
          described_class.new do
            size 5
          end
        end

        it 'defines the search clause' do
          expect(search.to_hash).to eq(size: 5)
        end
      end
    end

    context 'when a block is not provided' do

      context 'when a name is specified' do

        let(:search) do
          described_class.new(:last_tweet)
        end

        it 'defines the search clause' do
          expect(search.to_hash).to eq(name: :last_tweet)
        end
      end

      context 'when a name is not specified' do

        let(:search) do
          described_class.new
        end

        it 'defines the search clause' do
          expect(search.to_hash).to eq({ })
        end
      end
    end
  end
end

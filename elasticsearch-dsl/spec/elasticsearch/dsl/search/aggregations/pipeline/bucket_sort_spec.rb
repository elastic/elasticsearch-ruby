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

describe Elasticsearch::DSL::Search::Aggregations::BucketSort do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(bucket_sort: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#sort' do

      before do
        search.sort do
          by :category, order: 'desc'
        end
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_sort][:sort]).to eq([{ category: { order: 'desc' } }])
      end
    end

    describe '#from' do

      before do
        search.from(5)
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_sort][:from]).to eq(5)
      end
    end

    describe '#size' do

      before do
        search.size(10)
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_sort][:size]).to eq(10)
      end
    end

    describe '#gap_policy' do

      before do
        search.gap_policy('insert_zero')
      end

      it 'applies the option' do
        expect(search.to_hash[:bucket_sort][:gap_policy]).to eq('insert_zero')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          sort do
            by :total_sales, order: 'desc'
          end
          size 3
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(bucket_sort: { size: 3, sort: [{ total_sales: { order: 'desc' } }] })
      end
    end
  end
end

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

describe Elasticsearch::DSL::Search::Filters::GeoBoundingBox do

  describe '#to_hash' do

    let(:search) do
      described_class.new
    end

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(geo_bounding_box: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#top_left' do

      before do
        search.top_left('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:top_left]).to eq('bar')
      end
    end

    describe '#bottom_right' do

      before do
        search.bottom_right('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:bottom_right]).to eq('bar')
      end
    end

    describe '#top_right' do

      before do
        search.top_right('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:top_right]).to eq('bar')
      end
    end

    describe '#bottom_left' do

      before do
        search.bottom_left('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:bottom_left]).to eq('bar')
      end
    end

    describe '#top' do

      before do
        search.top('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:top]).to eq('bar')
      end
    end

    describe '#left' do

      before do
        search.left('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:left]).to eq('bar')
      end
    end

    describe '#bottom' do

      before do
        search.bottom('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:bottom]).to eq('bar')
      end
    end

    describe '#right' do

      before do
        search.right('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:geo_bounding_box][:right]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          top_left     [0,1]
          bottom_right [3,2]
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(geo_bounding_box: { top_left: [0,1], bottom_right: [3,2] })
      end
    end
  end
end

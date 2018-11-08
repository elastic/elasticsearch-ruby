require 'spec_helper'

describe Elasticsearch::DSL::Search::Aggregations::ScriptedMetric do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(scripted_metric: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new(:foo)
    end

    describe '#init_script' do

      before do
        search.init_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:init_script]).to eq('bar')
      end
    end

    describe '#map_script' do

      before do
        search.map_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:map_script]).to eq('bar')
      end
    end

    describe '#combine_script' do

      before do
        search.combine_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:combine_script]).to eq('bar')
      end
    end

    describe '#reduce_script' do

      before do
        search.reduce_script('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:reduce_script]).to eq('bar')
      end
    end

    describe '#params' do

      before do
        search.params('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:params]).to eq('bar')
      end
    end

    describe '#lang' do

      before do
        search.lang('bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:scripted_metric][:foo][:lang]).to eq('bar')
      end
    end
  end

  describe '#initialize' do

    context 'when a block is provided' do

      let(:search) do
        described_class.new do
          init_script 'bar'
        end
      end

      it 'executes the block' do
        expect(search.to_hash).to eq(scripted_metric: { init_script: 'bar' })
      end
    end
  end
end

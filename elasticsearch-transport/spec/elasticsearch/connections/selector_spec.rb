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

describe Elasticsearch::Transport::Transport::Connections::Selector do

  before do
    class BackupStrategySelector
      include Elasticsearch::Transport::Transport::Connections::Selector::Base

      def select(options={})
        connections.reject do |c|
          c.host[:attributes] && c.host[:attributes][:backup]
        end.sample
      end
    end
  end

  after do
    Object.send(:remove_const, :BackupStrategySelector)
  end

  let(:backup_strategy_selector) do
    BackupStrategySelector.new
  end

  describe 'the Random selector' do

    let(:connections) do
      [1, 2]
    end

    let(:selector) do
      described_class::Random.new(connections: connections)
    end

    it 'is initialized with connections' do
      expect(selector.connections).to eq(connections)
    end

    describe '#select' do

      let(:connections) do
        (0..19).to_a
      end

      it 'returns a connection' do
        expect(selector.select).to be_a(Integer)
      end

      context 'when multiple threads are used' do

        it 'allows threads to select connections in parallel' do
          expect(10.times.collect do
            threads = []
            20.times do
              threads << Thread.new do
                selector.select
              end
            end
            threads.map { |t| t.join }
            selector.select
          end).to all(be_a(Integer))
        end
      end
    end
  end

  describe 'the RoundRobin selector' do

    let(:connections) do
      ['A', 'B', 'C']
    end

    let(:selector) do
      described_class::RoundRobin.new(connections: connections)
    end

    it 'is initialized with connections' do
      expect(selector.connections).to eq(connections)
    end

    describe '#select' do

      it 'rotates over the connections' do
        expect(selector.select).to eq('A')
        expect(selector.select).to eq('B')
        expect(selector.select).to eq('C')
        expect(selector.select).to eq('A')
      end

      context 'when multiple threads are used' do

        let(:connections) do
          (0..19).to_a
        end

        it 'returns a connection' do
          expect(selector.select).to be_a(Integer)
        end

        it 'allows threads to select connections in parallel' do
          expect(10.times.collect do
            threads = []
            20.times do
              threads << Thread.new do
                selector.select
              end
            end
            threads.map { |t| t.join }
            selector.select
          end).to eq((0..9).to_a)
        end
      end
    end
  end

  describe 'a custom selector' do

    let(:connections) do
      [ double(host: { hostname: 'host1' }),
        double(host: { hostname: 'host2', attributes: { backup: true } }) ]
    end

    let(:selector) do
      BackupStrategySelector.new(connections: connections)
    end

    it 'is initialized with connections' do
      expect(selector.connections).to eq(connections)
    end

    describe '#select' do

      it 'applies the custom strategy' do
        10.times { expect(selector.select.host[:hostname]).to eq('host1') }
      end
    end
  end

  context 'when the Base module is included in a class' do

    before do
      class ExampleSelector
        include Elasticsearch::Transport::Transport::Connections::Selector::Base
      end
    end

    after do
      Object.send(:remove_const, :ExampleSelector)
    end

    it 'requires the #select method to be redefined' do
      expect {
        ExampleSelector.new.select
      }.to raise_exception(NoMethodError)
    end
  end
end

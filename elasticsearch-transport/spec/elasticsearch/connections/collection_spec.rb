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

describe Elasticsearch::Transport::Transport::Connections::Collection do

  describe '#initialize' do

    let(:collection) do
      described_class.new
    end

    it 'has an empty list of connections as a default' do
      expect(collection.connections).to be_empty
    end

    it 'has a default selector class' do
      expect(collection.selector).not_to be_nil
    end

    context 'when a selector class is specified' do

      let(:collection) do
        described_class.new(selector_class: Elasticsearch::Transport::Transport::Connections::Selector::Random)
      end

      it 'sets the selector' do
        expect(collection.selector).to be_a(Elasticsearch::Transport::Transport::Connections::Selector::Random)
      end
    end
  end

  describe '#get_connection' do

    let(:collection) do
      described_class.new(selector_class: Elasticsearch::Transport::Transport::Connections::Selector::Random)
    end

    before do
      expect(collection.selector).to receive(:select).and_return('OK')
    end

    it 'uses the selector to select a connection' do
      expect(collection.get_connection).to eq('OK')
    end
  end

  describe '#hosts' do

    let(:collection) do
      described_class.new(connections: [ double('connection', host: 'A'),
                                         double('connection', host: 'B') ])
    end

    it 'returns a list of hosts' do
      expect(collection.hosts).to eq([ 'A', 'B'])
    end
  end

  describe 'enumerable' do

    let(:collection) do
      described_class.new(connections: [ double('connection', host: 'A', dead?: false),
                                         double('connection', host: 'B', dead?: false) ])
    end

    describe '#map' do

      it 'responds to the method' do
        expect(collection.map { |c| c.host.downcase }).to eq(['a', 'b'])
      end
    end

    describe '#[]' do

      it 'responds to the method' do
        expect(collection[0].host).to eq('A')
        expect(collection[1].host).to eq('B')
      end
    end

    describe '#size' do

      it 'responds to the method' do
        expect(collection.size).to eq(2)
      end
    end

    context 'when a connection is marked as dead' do

      let(:collection) do
        described_class.new(connections: [ double('connection', host: 'A', dead?: true),
                                           double('connection', host: 'B', dead?: false) ])
      end

      it 'does not enumerate the dead connections' do
        expect(collection.size).to eq(1)
        expect(collection.collect { |c| c.host }).to eq(['B'])
      end

      context '#alive' do

        it 'enumerates the alive connections' do
          expect(collection.alive.collect { |c| c.host }).to eq(['B'])
        end
      end

      context '#dead' do

        it 'enumerates the alive connections' do
          expect(collection.dead.collect { |c| c.host }).to eq(['A'])
        end
      end
    end
  end

  describe '#add' do

    let(:collection) do
      described_class.new(connections: [ double('connection', host: 'A', dead?: false),
                                         double('connection', host: 'B', dead?: false) ])
    end

    context 'when an array is provided' do

      before do
        collection.add([double('connection', host: 'C', dead?: false),
                        double('connection', host: 'D', dead?: false)])
      end

      it 'adds the connections' do
        expect(collection.size).to eq(4)
      end
    end

    context 'when an element is provided' do

      before do
        collection.add(double('connection', host: 'C', dead?: false))
      end

      it 'adds the connection' do
        expect(collection.size).to eq(3)
      end
    end
  end

  describe '#remove' do

    let(:connections) do
      [ double('connection', host: 'A', dead?: false),
        double('connection', host: 'B', dead?: false) ]
    end

    let(:collection) do
      described_class.new(connections: connections)
    end

    context 'when an array is provided' do

      before do
        collection.remove(connections)
      end

      it 'removes the connections' do
        expect(collection.size).to eq(0)
      end
    end

    context 'when an element is provided' do

      let(:connections) do
        [ double('connection', host: 'A', dead?: false),
          double('connection', host: 'B', dead?: false) ]
      end

      before do
        collection.remove(connections.first)
      end

      it 'removes the connection' do
        expect(collection.size).to eq(1)
      end
    end
  end

  describe '#get_connection' do

    context 'when all connections are dead' do

      let(:connection_a) do
        Elasticsearch::Transport::Transport::Connections::Connection.new(host: { host: 'A' })
      end

      let(:connection_b) do
        Elasticsearch::Transport::Transport::Connections::Connection.new(host: { host: 'B' })
      end

      let(:collection) do
        described_class.new(connections: [connection_a, connection_b])
      end

      before do
        connection_a.dead!.dead!
        connection_b.dead!
      end

      it 'returns the connection with the least failures' do
        expect(collection.get_connection.host[:host]).to eq('B')
      end
    end

    context 'when multiple threads are used' do

      let(:connections) do
        20.times.collect do |i|
          Elasticsearch::Transport::Transport::Connections::Connection.new(host: { host: i })
        end
      end

      let(:collection) do
        described_class.new(connections: connections)
      end

      it 'allows threads to select connections in parallel' do
       expect(10.times.collect do
          threads = []
          20.times do
            threads << Thread.new do
              collection.get_connection
            end
          end
          threads.map { |t| t.join }
          collection.get_connection.host[:host]
        end).to eq((0..9).to_a)
      end

      it 'always returns a connection' do
        threads = 20.times.map do
          Thread.new do
            20.times.map do
              collection.get_connection.dead!
            end
          end
        end

        expect(threads.flat_map(&:value).size).to eq(400)
      end
    end
  end
end

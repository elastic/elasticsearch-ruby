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

describe Elasticsearch::API::Utils do
  let(:utils) do
    Class.new { include Elasticsearch::API::Utils }.new
  end

  describe '#escape' do
    it 'encodes Unicode characters' do
      expect(utils.escape('中文')).to eq('%E4%B8%AD%E6%96%87')
    end

    it 'encodes special characters' do
      expect(utils.escape('foo bar')).to eq('foo%20bar')
      expect(utils.escape('foo/bar')).to eq('foo%2Fbar')
      expect(utils.escape('foo^bar')).to eq('foo%5Ebar')
    end

    it 'does not encode asterisks' do
      expect(utils.escape('*')).to eq('*')
    end
  end

  describe '#listify' do
    it 'creates a list from a single value' do
      expect(utils.listify('foo')).to eq('foo')
    end

    it 'creates a list from an array' do
      expect(utils.listify(['foo', 'bar'])).to eq('foo,bar')
    end

    it 'creates a list from multiple arguments' do
      expect(utils.listify('foo', 'bar')).to eq('foo,bar')
    end

    it 'ignores nil values' do
      expect(utils.listify(['foo', nil, 'bar'])).to eq('foo,bar')
    end

    it 'ignores special characters' do
      expect(utils.listify(['foo', 'bar^bam'])).to eq('foo,bar%5Ebam')
    end

    context 'when the escape option is set to false' do
      it 'does not escape the characters' do
        expect(utils.listify(['foo', 'bar^bam'], escape: false)).to eq('foo,bar^bam')
      end
    end
  end

  describe '#pathify' do
    it 'creates a path from a single value' do
      expect(utils.pathify('foo')).to eq('foo')
    end

    it 'creates a path from an array' do
      expect(utils.pathify(['foo', 'bar'])).to eq('foo/bar')
    end

    it 'ignores nil values' do
      expect(utils.pathify(['foo', nil, 'bar'])).to eq('foo/bar')
    end

    it 'ignores empty string values' do
      expect(utils.pathify(['foo', '', 'bar'])).to eq('foo/bar')
    end
  end

  describe '#bulkify' do
    context 'when the input is an array of hashes' do
      let(:result) do
        utils.bulkify [
          { index: { _index: 'myindexA', _id: '1', data: { title: 'Test' } } },
          { update: { _index: 'myindexB', _id: '2', data: { doc: { title: 'Update' } } } },
          { delete: { _index: 'myindexC', _id: '3' } }
        ]
      end

      let(:expected_string) do
        <<-PAYLOAD.gsub(/^\s+/, '')
                {"index":{"_index":"myindexA","_id":"1"}}
                {"title":"Test"}
                {"update":{"_index":"myindexB","_id":"2"}}
                {"doc":{"title":"Update"}}
                {"delete":{"_index":"myindexC","_id":"3"}}
        PAYLOAD
      end

      it 'serializes the hashes' do
        expect(result).to eq(expected_string)
      end
    end

    context 'when the input is an array of strings' do

      let(:result) do
        utils.bulkify(['{"foo":"bar"}','{"moo":"bam"}'])
      end

      let(:expected_string) do
        <<-PAYLOAD.gsub(/^\s+/, '')
              {"foo":"bar"}
              {"moo":"bam"}
        PAYLOAD
      end

      it 'serializes the array of strings' do
        expect(result).to eq(expected_string)
      end
    end

    context 'when the input is an array of header/data pairs' do

      let(:result) do
        utils.bulkify([{ foo: 'bar' }, { moo: 'bam' },{ foo: 'baz' }])
      end

      let(:expected_string) do
        <<-PAYLOAD.gsub(/^\s+/, '')
              {"foo":"bar"}
              {"moo":"bam"}
              {"foo":"baz"}
        PAYLOAD
      end

      it 'serializes the array of strings' do
        expect(result).to eq(expected_string)
      end
    end

    context 'when the payload has the :data option' do

      let(:input) do
        { index: { foo: 'bar', data: { moo: 'bam' } } }
      end

      let(:result) do
        utils.bulkify([input])
      end

      let(:expected_string) do
        <<-PAYLOAD.gsub(/^\s+/, '')
              {"index":{"foo":"bar"}}
              {"moo":"bam"}
        PAYLOAD
      end

      it 'does not mutate the input' do
        expect(input[:index][:data]).to eq(moo: 'bam')
      end

      it 'serializes the array of strings' do
        expect(result).to eq(expected_string)
      end
    end

    context 'when the payload has nested :data options' do
      let(:data) do
        { data: { a: 'b', data: { c: 'd' } } }
      end

      let(:result) do
        utils.bulkify([{ index: { foo: 'bar'} } , data])
      end

      let(:lines) do
        result.split("\n")
      end

      let(:header) do
        MultiJson.load(lines.first)
      end

      let(:data_string) do
        MultiJson.load(lines.last)
      end

      it 'does not mutate the input' do
        expect(data[:data]).to eq(a: 'b', data: { c: 'd' })
      end

      it 'serializes the array of strings' do
        expect(header['index']['foo']).to eq('bar')
        expect(data_string['data']['a']).to eq('b')
        expect(data_string['data']['data']['c']).to eq('d')
      end
    end
  end

  context '#__validate_and_extract_params' do
    it 'listify Arrays' do
      expect(utils.process_params({ foo: ['a', 'b'] })).to eq(foo: 'a,b')
    end

    it 'does not escape the parameters' do
      expect(utils.process_params({ foo: ['a.*', 'b.*'] })).to eq(foo: 'a.*,b.*')
    end

    context 'when the params are valid' do
      it 'extracts the valid params from the hash' do
        expect(utils.process_params({ foo: 'qux' })).to eq(foo: 'qux')
      end
    end
  end

  describe '#extract_parts' do
    it 'extracts parts with true value from a Hash' do
      expect(utils.extract_parts({ foo: true, moo: 'blah' })).to eq(['foo', 'blah'])
    end

    it 'extracts parts with string value from a Hash' do
      expect(utils.extract_parts({ foo: 'qux', moo: 'blah' })).to eq(['qux', 'blah'])
    end
  end

  context '#rescue_from_not_found' do
    it 'returns false if exception class name contains \'NotFound\'' do
      expect(utils.rescue_from_not_found { raise NotFound }).to be(false)
    end

    it 'returns false if exception message contains \'Not Found\'' do
      expect(utils.rescue_from_not_found { raise StandardError.new "Not Found" }).to be(false)
      expect(utils.rescue_from_not_found { raise StandardError.new "NotFound" }).to be(false)
    end

    it 'raises the exception if the class name and message do not include \'NotFound\'' do
      expect {
        utils.rescue_from_not_found { raise StandardError.new "Any other exception" }
      }.to raise_exception(StandardError)
    end
  end
end

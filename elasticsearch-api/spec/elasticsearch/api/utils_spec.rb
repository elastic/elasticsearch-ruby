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

  describe '#__escape' do

    it 'encodes Unicode characters' do
      expect(utils.__escape('中文')).to eq('%E4%B8%AD%E6%96%87')
    end

    it 'encodes special characters' do
      expect(utils.__escape('foo bar')).to eq('foo+bar')
      expect(utils.__escape('foo/bar')).to eq('foo%2Fbar')
      expect(utils.__escape('foo^bar')).to eq('foo%5Ebar')
    end

    it 'does not encode asterisks' do
      expect(utils.__escape('*')).to eq('*')
    end

    it 'users CGI.escape by default' do
      expect(CGI).to receive(:escape).and_call_original
      expect(utils.__escape('foo bar')).to eq('foo+bar')
    end

    it 'uses the escape_utils gem when available', unless: defined?(JRUBY_VERSION) do
      require 'escape_utils'
      expect(CGI).not_to receive(:escape)
      expect(EscapeUtils).to receive(:escape_url).and_call_original
      expect(utils.__escape('foo bar')).to eq('foo+bar')
    end
  end

  describe '#__listify' do

    it 'creates a list from a single value' do
      expect(utils.__listify('foo')).to eq('foo')
    end

    it 'creates a list from an array' do
      expect(utils.__listify(['foo', 'bar'])).to eq('foo,bar')
    end

    it 'creates a list from multiple arguments' do
      expect(utils.__listify('foo', 'bar')).to eq('foo,bar')
    end

    it 'ignores nil values' do
      expect(utils.__listify(['foo', nil, 'bar'])).to eq('foo,bar')
    end

    it 'ignores special characters' do
      expect(utils.__listify(['foo', 'bar^bam'])).to eq('foo,bar%5Ebam')
    end

    context 'when the escape option is set to false' do

      it 'does not escape the characters' do
        expect(utils.__listify(['foo', 'bar^bam'], :escape => false)).to eq('foo,bar^bam')
      end
    end
  end

  describe '#__pathify' do

    it 'creates a path from a single value' do
      expect(utils.__pathify('foo')).to eq('foo')
    end

    it 'creates a path from an array' do
      expect(utils.__pathify(['foo', 'bar'])).to eq('foo/bar')
    end

    it 'ignores nil values' do
      expect(utils.__pathify(['foo', nil, 'bar'])).to eq('foo/bar')
    end

    it 'ignores empty string values' do
      expect(utils.__pathify(['foo', '', 'bar'])).to eq('foo/bar')
    end
  end

  describe '#__bulkify' do

    context 'when the input is an array of hashes' do

      let(:result) do
        utils.__bulkify [
          { :index =>  { :_index => 'myindexA', :_type => 'mytype', :_id => '1', :data => { :title => 'Test' } } },
          { :update => { :_index => 'myindexB', :_type => 'mytype', :_id => '2', :data => { :doc => { :title => 'Update' } } } },
          { :delete => { :_index => 'myindexC', :_type => 'mytypeC', :_id => '3' } }
        ]
      end

      let(:expected_string) do
        <<-PAYLOAD.gsub(/^\s+/, '')
                {"index":{"_index":"myindexA","_type":"mytype","_id":"1"}}
                {"title":"Test"}
                {"update":{"_index":"myindexB","_type":"mytype","_id":"2"}}
                {"doc":{"title":"Update"}}
                {"delete":{"_index":"myindexC","_type":"mytypeC","_id":"3"}}
        PAYLOAD
      end

      it 'serializes the hashes' do
        expect(result).to eq(expected_string)
      end
    end

    context 'when the input is an array of strings' do

      let(:result) do
        utils.__bulkify(['{"foo":"bar"}','{"moo":"bam"}'])
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
        utils.__bulkify([{ foo: 'bar' }, { moo: 'bam' },{ foo: 'baz' }])
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
        utils.__bulkify([input])
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
        utils.__bulkify([{ index: { foo: 'bar'} } , data])
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
      expect(utils.__validate_and_extract_params({ foo: ['a', 'b'] }, [:foo] )).to eq(foo: 'a,b')
    end

    it 'does not escape the parameters' do
      expect(utils.__validate_and_extract_params({ foo: ['a.*', 'b.*'] }, [:foo] )).to eq(foo: 'a.*,b.*')
    end

    context 'when the params are valid' do

      it 'extracts the valid params from the hash' do
        expect(utils.__validate_and_extract_params({ foo: 'qux' }, [:foo, :bar]) ).to eq(foo: 'qux')
      end
    end

    context 'when the params are invalid' do

      it 'raises an ArgumentError' do
        expect {
          utils.__validate_and_extract_params({ foo: 'qux', bam: 'mux' }, [:foo, :bar])
        }.to raise_exception(ArgumentError)
      end
    end

    context 'when COMMON_PARAMS are provided' do

      it 'extracts the params' do
        expect(utils.__validate_and_extract_params({ index: 'foo'}, [:foo])).to eq({})
      end
    end

    context 'when COMMON_QUERY_PARAMS are provided' do

      it 'extracts the params' do
        expect(utils.__validate_and_extract_params(format: 'yaml')).to eq(format: 'yaml')
      end
    end

    context 'when the :skip_paramter_validation option is set' do

      let(:result) do
        utils.__validate_and_extract_params( { foo: 'q', bam: 'm' }, [:foo, :bar], { skip_parameter_validation: true } )
      end

      it 'skips parameter validation' do
        expect(result).to eq(foo: 'q', bam: 'm')
      end
    end

    context 'when the module has the setting to skip parameter validation' do

      around do |example|
        original_value = Elasticsearch::API.settings[:skip_parameter_validation]
        Elasticsearch::API.settings[:skip_parameter_validation] = true
        example.run
        Elasticsearch::API.settings[:skip_parameter_validation] = original_value
      end

      let(:result) do
        utils.__validate_and_extract_params( { foo: 'q', bam: 'm' }, [:foo, :bar])
      end

      it 'applies the module setting' do
        expect(result).to eq(foo: 'q', bam: 'm')
      end
    end
  end

  describe '#__extract_parts' do

    it 'extracts parts with true value from a Hash' do
      expect(utils.__extract_parts({ foo: true, moo: 'blah' }, [:foo, :bar])).to eq(['foo'])
    end

    it 'extracts parts with string value from a Hash' do
      expect(utils.__extract_parts({ foo: 'qux', moo: 'blah' }, [:foo, :bar])).to eq(['qux'])
    end
  end

  context '#__rescue_from_not_found' do

    it 'returns false if exception class name contains \'NotFound\'' do
      expect(utils.__rescue_from_not_found { raise NotFound }).to be(false)
    end

    it 'returns false if exception message contains \'Not Found\'' do
      expect(utils.__rescue_from_not_found { raise StandardError.new "Not Found" }).to be(false)
      expect(utils.__rescue_from_not_found { raise StandardError.new "NotFound" }).to be(false)
    end

    it 'raises the exception if the class name and message do not include \'NotFound\'' do
      expect {
        utils.__rescue_from_not_found { raise StandardError.new "Any other exception" }
      }.to raise_exception(StandardError)
    end
  end

  context '#__report_unsupported_parameters' do

    context 'when the parameters are passed as Symbols' do

      let(:arguments) do
        { foo: 'bar', moo: 'bam', baz: 'qux' }
      end

      let(:unsupported_params) do
        [ :foo, :moo]
      end

      let(:message) do
        message = ''
        expect(Kernel).to receive(:warn) { |msg| message = msg }
        utils.__report_unsupported_parameters(arguments, unsupported_params)
        message
      end

      it 'prints the unsupported parameters' do
        expect(message).to match(/You are using unsupported parameter \[\:foo\]/)
        expect(message).to match(/You are using unsupported parameter \[\:moo\]/)
      end
    end

    context 'when the parameters are passed as Hashes' do

      let(:arguments) do
        { foo: 'bar', moo: 'bam', baz: 'qux' }
      end

      let(:unsupported_params) do
        [ :foo, :moo]
      end

      let(:message) do
        message = ''
        expect(Kernel).to receive(:warn) { |msg| message = msg }
        utils.__report_unsupported_parameters(arguments, unsupported_params)
        message
      end

      it 'prints the unsupported parameters' do
        expect(message).to match(/You are using unsupported parameter \[\:foo\]/)
        expect(message).to match(/You are using unsupported parameter \[\:moo\]/)
      end
    end

    context 'when the parameters are passed as a mix of Hashes and Symbols' do

      let(:arguments) do
        { foo: 'bar', moo: 'bam', baz: 'qux' }
      end

      let(:unsupported_params) do
        [ { :foo => { :explanation => 'NOT_SUPPORTED'} }, :moo ]
      end


      let(:message) do
        message = ''
        expect(Kernel).to receive(:warn) { |msg| message = msg }
        utils.__report_unsupported_parameters(arguments, unsupported_params)
        message
      end

      it 'prints the unsupported parameters' do
        expect(message).to match(/You are using unsupported parameter \[\:foo\]/)
        expect(message).to match(/You are using unsupported parameter \[\:moo\]/)
        expect(message).to match(/NOT_SUPPORTED/)
      end
    end

    context 'when unsupported parameters are unused' do

      let(:arguments) do
        { moo: 'bam', baz: 'qux' }
      end

      let(:unsupported_params) do
        [ :foo ]
      end

      it 'prints the unsupported parameters' do
        expect(Kernel).not_to receive(:warn)
        utils.__report_unsupported_parameters(arguments, unsupported_params)
      end
    end
  end

  describe '#__report_unsupported_method' do

    let(:message) do
      message = ''
      expect(Kernel).to receive(:warn) { |msg| message = msg }
      utils.__report_unsupported_method(:foo)
      message
    end

    it 'prints a warning' do
      expect(message).to match(/foo/)
    end
  end
end

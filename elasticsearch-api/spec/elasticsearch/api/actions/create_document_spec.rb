require 'spec_helper'

describe 'client#create_document' do

  let(:expected_args) do
    [
        'PUT',
        'foo/bar/123',
        { op_type: 'create' },
        { foo: 'bar' }
    ]
  end

  it 'performs the request' do
    expect(client_double.create(index: 'foo', type: 'bar', id: '123', body: { foo: 'bar'})).to eq({})
  end

  context 'when the request needs to be URL-escaped' do

    let(:expected_args) do
      [
          'PUT',
          'foo/bar%2Fbam/123',
          { op_type: 'create' },
          { }
      ]
    end

    it 'performs the request' do
      expect(client_double.create(index: 'foo', type: 'bar/bam', id: '123', body: {})).to eq({})
    end
  end

  context 'when an id is provided as an integer' do

    let(:expected_args) do
      [
          'PUT',
          'foo/bar/1',
          { op_type: 'create' },
          { foo: 'bar' }
      ]
    end

    it 'updates the arguments with the `op_type`' do
      expect(client_double.create(index: 'foo', type: 'bar', id: 1, body: { foo: 'bar' })).to eq({})
    end
  end

  context 'when an id is not provided' do

    let(:expected_args) do
      [
          'POST',
          'foo/bar',
          { },
          { foo: 'bar' }
      ]
    end

    it 'updates the arguments with the `op_type`' do
      expect(client_double.create(index: 'foo', type: 'bar', body: { foo: 'bar' })).to eq({})
    end
  end
end

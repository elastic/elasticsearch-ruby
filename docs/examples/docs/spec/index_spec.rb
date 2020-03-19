# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require_relative 'spec_helper'

describe 'Index documentation examples' do

  context 'documentation examples' do
    let(:client) do
      DEFAULT_CLIENT
    end

    before do
      client.indices.create(index: 'twitter')
    end

    after do
      client.indices.delete(index: 'twitter')
    end

    it 'executes the example code: - bb143628fd04070683eeeadc9406d9cc' do
      # tag::bb143628fd04070683eeeadc9406d9cc[]
      response = client.index(index: 'twitter', id: 1, body: {
          user: 'kimchy',
          post_date: '2009-11-15T14:12:12',
          message: 'tryng out Elasticsearch'
      })
      # end::bb143628fd04070683eeeadc9406d9cc[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    # @todo
    it 'executes the example code: - 804a97ff4d0613e6568e4efb19c52021' do
      # tag::804a97ff4d0613e6568e4efb19c52021[]
      # end::804a97ff4d0613e6568e4efb19c52021[]

      puts '-' * 50
      #puts response
      puts '-' * 50
    end

    it 'executes the example code: - d718b63cf1b6591a1d59a0cf4fd995eb' do
      # tag::d718b63cf1b6591a1d59a0cf4fd995eb[]
      response = client.index(index: 'twitter', id: 1, op_type: 'create',
        body: {
          user: 'kimchy',
          post_date: '2009-11-15T14:12:12',
          message: 'tryng out Elasticsearch'
      })
      # end::d718b63cf1b6591a1d59a0cf4fd995eb[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 048d8abd42d094bbdcf4452a58ccb35b' do
      # tag::048d8abd42d094bbdcf4452a58ccb35b[]
      response = client.create(index: 'twitter', id: 1,
                              body: {
                                  user: 'kimchy',
                                  post_date: '2009-11-15T14:12:12',
                                  message: 'tryng out Elasticsearch'
                              })
      # end::048d8abd42d094bbdcf4452a58ccb35b[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 36818c6d9f434d387819c30bd9addb14' do
      # tag::36818c6d9f434d387819c30bd9addb14[]
      response = client.index(index: 'twitter',
                              body: {
                                user: 'kimchy',
                                post_date: '2009-11-15T14:12:12',
                                message: 'tryng out Elasticsearch'
                              })
      # end::36818c6d9f434d387819c30bd9addb14[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 625dc94df1f9affb49a082fd99d41620' do
      # tag::625dc94df1f9affb49a082fd99d41620[]
      response = client.index(index: 'twitter', id: 1,
                              body: {
                                  user: 'kimchy',
                                  post_date: '2009-11-15T14:12:12',
                                  message: 'tryng out Elasticsearch'
                              },
                              routing: 'kimchy')
      # end::625dc94df1f9affb49a082fd99d41620[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - b918d6b798da673a33e49b94f61dcdc0' do
      # tag::b918d6b798da673a33e49b94f61dcdc0[]
      response = client.index(index: 'twitter', id: 1,
                              body: {
                                  user: 'kimchy',
                                  post_date: '2009-11-15T14:12:12',
                                  message: 'tryng out Elasticsearch'
                              },
                              timeout: '5m')
      # end::b918d6b798da673a33e49b94f61dcdc0[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end

    it 'executes the example code: - 1f336ecc62480c1d56351cc2f82d0d08' do
      # tag::1f336ecc62480c1d56351cc2f82d0d08[]
      response = client.index(index: 'twitter', id: 1,
                              body: {
                                  user: 'kimchy',
                                  post_date: '2009-11-15T14:12:12',
                                  message: 'tryng out Elasticsearch'
                              },
                              version: 2,
                              version_type: 'external')
      # end::1f336ecc62480c1d56351cc2f82d0d08[]

      puts '-' * 50
      puts response
      puts '-' * 50
    end
  end
end

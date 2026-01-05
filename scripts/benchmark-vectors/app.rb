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

require 'elasticsearch'
require 'elasticsearch/helpers/bulk_helper'
require 'json'

# Download file if not present:
filename = './open_ai_corpus-initial-indexing-1k.json'
unless File.file?(filename)
  file_url = 'https://rally-tracks.elastic.co/openai_vector/open_ai_corpus-initial-indexing-1k.json.bz2'
  response = Net::HTTP.get_response(URI(file_url))
  File.write(File.expand_path("./#{filename}.bz2", __dir__), response.body)
  `bzip2 -d #{filename}.bz2`
end
data = File.read(File.expand_path(filename, __dir__))

@json_data = data.strip.gsub("\n", ',')
@index = 'vector64'
@client = Elasticsearch::Client.new(compression: false)

@client.indices.delete(index: @index, ignore: 404)

def create_index
  @client.indices.create(
    index: @index,
    body: {
      mappings: {
        properties: {
          emb: { type: 'dense_vector', dims: 1536, index_options: { type: 'flat' } },
          docid: { type: 'keyword' },
          title: { type: 'text' },
          text: {
            fields: {
              keyword: {
                ignore_above: 256,
                type: 'keyword'
              }
            },
            type: 'text'
          }
        }
      }
    }
  )
  @client.indices.refresh(index: @index)
end

def benchmark(data, chunk_size, vector: false)
  bulk_helper = Elasticsearch::Helpers::BulkHelper.new(@client, @index)

  start = Time.now
  20.times do # repeat the dataset until 20k reached (1_000 * 20)
    json = JSON.parse("[#{data}]")

    json.each_slice(chunk_size) do |slice|
      slice = slice.map { |j| j['emb'] = @client.pack_dense_vector(j['emb']) } if vector
      bulk_helper.ingest(slice)
    end
  end
  time = (Time.now - start) * 1000
  @client.indices.delete(index: @index)
  time
end

@results = []

def ingest_the_data
  [100, 250, 500, 1000].each do |chunk_size|
    create_index
    duration32 = benchmark(@json_data, chunk_size)
    create_index
    duration64 = benchmark(@json_data, chunk_size, vector: true)
    # Create the result hash for JSON, or add the time to existing result in array which can later
    # be averaged:
    if (result = @results.find { |a| a[:chunk_size] == chunk_size })
      result[:float32][:duration] << duration32
      result[:base64][:duration] << duration64
    else
      result = {
        dataset_size: 20_000,
        chunk_size: chunk_size,
        float32: { duration: [duration32] },
        base64: { duration: [duration64] }
      }
      @results << result
    end
  end
end

# Do 3 passes and get the average
3.times { ingest_the_data }
@results.each do |result|
  result[:float32][:duration] = (result[:float32][:duration].sum / 3)
  result[:base64][:duration] = (result[:base64][:duration].sum / 3)

  docs32 = (20_000 / result[:float32][:duration]) * 1000
  docs64 = (20_000 / result[:base64][:duration]) * 1000

  puts "Chunk size #{result[:chunk_size]} | " \
       "Float32: #{(result[:float32][:duration] / 1_000).round(2)}s, #{docs32.round(2)} docs/s | " \
       "Base64: #{(result[:base64][:duration] / 1_000).round(2)}s, #{docs64.round(2)} docs/s"
end

puts JSON.pretty_generate(JSON.parse(@results.to_json))
# Write JSON results:
File.write(File.expand_path('./results.json', __dir__), @results.to_json)

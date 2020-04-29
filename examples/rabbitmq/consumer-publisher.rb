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

# Example of listening to a RabbitMQ queue and indexing the payload
#
# Usage:
#
#     $ bundle install
#     $ bundle exec ruby consume-publish.rb
#

require 'multi_json'
require 'oj'

require 'elasticsearch'

require 'bunny'

connection = Bunny.new

connection.start

channel  = connection.create_channel
queue    = channel.queue 'examples.elasticsearch', auto_delete: true
exchange = channel.default_exchange

elasticsearch = Elasticsearch::Client.new log:true

elasticsearch.indices.delete index: 'rabbit' rescue nil

queue.subscribe do |delivery_info, metadata, payload|
  hash = MultiJson.load(payload)
  elasticsearch.index index: 'rabbit', type: 'event', id: hash.delete(:id), body: hash
end

(1..10).each do |i|
  exchange.publish MultiJson.dump({id: i, title: "Test #{i}"}), routing_key: queue.name
end

sleep 1.0

puts "Enter some words to index (use Ctrl+C to exit):"

[:INT, :TERM].each do |signal| trap(signal) { puts "\nExiting..."; exit } end

while input = gets
  exchange.publish MultiJson.dump({title: input.chomp}), routing_key: queue.name unless input =~ /^\s*$/
end

connection.close

# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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

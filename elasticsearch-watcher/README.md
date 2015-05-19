# Elasticsearch::Watcher

This library provides Ruby API for the [_Watcher_](https://www.elastic.co/products/watcher) plugin.

Please refer to the [_Watcher_ documentation](http://www.elastic.co/guide/en/watcher/current/index.html)
for information about the plugin.

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-watcher

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch-watcher', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch-watcher
    bundle install
    rake install

## Usage

The documentation for the Ruby API methods is available at <http://www.rubydoc.info/gems/elasticsearch-watcher>.

A comprehensive example of registering a watch, triggering the actions, and getting information
about the watch execution is quoted below.

```ruby
require 'elasticsearch'
require 'elasticsearch/watcher'

client = Elasticsearch::Client.new url: 'http://localhost:9200', log: true
client.transport.logger.formatter = proc do |severity, datetime, progname, msg| "\e[2m#{msg}\e[0m\n" end

# Delete the Watcher and test indices
#
client.indices.delete index: ['alerts', 'test', '.watches', '.watch_history*'], ignore: 404

# Print information about the Watcher plugin
#
puts "Watcher #{client.watcher.info['version']['number']}"

# Register a new watch
#
client.watcher.put_watch id: 'error_500', body: {
  # Label the watch
  #
  metadata: { tags: ['errors'] },

  # Run the watch every 10 seconds
  #
  trigger: { schedule: { interval: '10s' } },

  # Search for at least 3 documents matching the condition
  #
  condition: {  script: { inline: 'ctx.payload.hits.total > 3' } },

  # Throttle the watch execution for 30 seconds
  #
  throttle_period: '30s',

  # The search request to execute
  #
  input:   { search: {
               request: {
                 indices: ['test'],
                 body: {
                   query: {
                     filtered: {
                       query: { match: { status: 500 } },
                       filter: { range: { timestamp: { from: '{{ctx.trigger.scheduled_time}}||-5m', to: '{{ctx.trigger.triggered_time}}' } } }
                     }
                   },
                   # Return statistics about different hosts
                   #
                   aggregations: {
                    hosts: { terms: { field: 'host' } }
                   }
                 }}}},

  # The actions to perform
  #
  actions: {
    send_email:    {
      transform: {
        # Transform the data for the template
        #
        script: 'return [ total: ctx.payload.hits.total, hosts: ctx.payload.aggregations.hosts.buckets.collect { [ host: it.key, errors: it.doc_count ] }, errors: ctx.payload.hits.hits.collect { it._source } ];'
      },
      email: { to:        'alerts@example.com',
               subject:   '[ALERT] {{ctx.watch_id}}',
               body:      "Received {{ctx.payload.total}} error documents in the last 5 minutes.\n\nHosts:\n\n{{#ctx.payload.hosts}}* {{host}} ({{errors}})\n{{/ctx.payload.hosts}}",
               attach_data: true }
    },
    index_payload: {
      # Transform the data to be stored
      #
      transform: { script: 'return [ watch_id: ctx.watch_id, payload: ctx.payload ]' },
      index: { index: 'alerts', doc_type: 'alert' }
    },
    ping_webhook: {
      webhook: {
        method: 'POST',
        host:   'localhost',
        port:   4567,
        path:   '/',
        body:   %q|{"watch_id" : "{{ctx.watch_id}}", "payload" : "{{ctx.payload}}"}| }
    }
  }
}

# Index documents to trigger the watch
#
5.times do
  client.index index: 'test', type: 'd',
               body: { timestamp: Time.now.utc.iso8601, status: 500, host: "10.0.0.#{rand(1..3)}" }
end

# Wait a bit...
#
print "Waiting 30 seconds..."
$i=0; while $i < 30 do
  sleep(1); print('.'); $i+=1
end; puts "\n"

# Display information about watch execution
#
puts '='*80, ""
client.search(index: '.watch_history*', q: 'watch_id:error_500', sort: 'trigger_event.schedule.triggered_time:asc')['hits']['hits'].each do |r|
  puts "#{r['_id']} : #{r['_source']['state']}"
end

# Delete the watch
#
puts "Deleting the watch..."
client.watcher.delete_watch id: 'error_500', master_timeout: '30s', force: true
```

You can run a simple [Sinatra](https://github.com/sinatra/sinatra/) server
to test the `webhook` action with the following Ruby code:

```bash
ruby -r sinatra -r json -e 'post("/") { json = JSON.parse(request.body.read); puts %Q~Received #{json["watch_id"]} with payload: #{json["payload"]}~ }'
```

## License

This software is licensed under the Apache 2 license, quoted below.

    Copyright (c) 2015 Elasticsearch <http://www.elasticsearch.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

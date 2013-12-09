# Elasticsearch::Extensions

This library provides a set of extensions to the
[`elasticsearch`](https://github.com/elasticsearch/elasticsearch-ruby) Rubygem.

## Extensions

### ANSI

Colorize and format selected  Elasticsearch response parts in terminal:

Display formatted search results:

    require 'elasticsearch/extensions/ansi'
    puts Elasticsearch::Client.new.search.to_ansi

Display a table with the output of the `_analyze` API:

    require 'elasticsearch/extensions/ansi'
    puts Elasticsearch::Client.new.indices.analyze(text: 'Quick Brown Fox Jumped').to_ansi

[Full documentation](http://rubydoc.info/gems/elasticsearch-extensions/Elasticsearch/Extensions/ANSI)

### Test::Cluster

Allows to programatically start and stop an Elasticsearch cluster suitable for isolating tests.

HTTP service is running on ports `9250-*` by default, and the cluster runs in-memory only.

Start and stop the default cluster:

    require 'elasticsearch/extensions/test/cluster'

    Elasticsearch::Extensions::Test::Cluster.start
    Elasticsearch::Extensions::Test::Cluster.stop

Start the cluster on specific port, with a specific Elasticsearch version, number of nodes and cluster name:

    require 'elasticsearch/extensions/test/cluster'

    Elasticsearch::Extensions::Test::Cluster.start \
      cluster_name: "my-testing-cluster",
      command:      "/usr/local/Cellar/elasticsearch/1.0.0.Beta2/bin/elasticsearch",
      nodes:        3,
      port:         9350

    # Starting 3 Elasticsearch nodes.....................
    # --------------------------------------------------------------------------------
    # Cluster:            my-testing-cluster
    # Status:             green
    # Nodes:              3
    #                     - node-1 | version: 1.0.0.Beta2, pid: 54469
    #                     + node-2 | version: 1.0.0.Beta2, pid: 54470
    #                     - node-3 | version: 1.0.0.Beta2, pid: 54468
    # => true


Stop this cluster:

    require 'elasticsearch/extensions/test/cluster'

    Elasticsearch::Extensions::Test::Cluster.stop \
      command:      "/usr/local/Cellar/elasticsearch/1.0.0.Beta2/bin/elasticsearch",
      port:         9350

    # Stopping Elasticsearch nodes... stopped PID 54469. stopped PID 54470. stopped PID 54468.
    # # => [54469, 54470, 54468]

[Full documentation](http://rubydoc.info/gems/elasticsearch-extensions/Elasticsearch/Extensions/Test/Cluster)

### Test::StartupShutdown

Allows to register `startup` and `shutdown` hooks for Test::Unit, similarly to RSpec's `before(:all)`,
compatible with the [Test::Unit 2](https://github.com/test-unit/test-unit/blob/master/lib/test/unit/testcase.rb) syntax.

The extension is useful for e.g. starting the testing Elasticsearch cluster before the test suite is executed,
and stopping it afterwards.

** IMPORTANT NOTE ** You have to register the handler for `shutdown` hook before requiring 'test/unit':

    # File: test_helper.rb
    at_exit { MyTest.__run_at_exit_hooks }
    require 'test/unit'

Example of handler registration:

    class MyTest < Test::Unit::TestCase
      extend Elasticsearch::Extensions::Test::StartupShutdown

      startup  { puts "Suite starting up..." }
      shutdown { puts "Suite shutting down..." }
    end

[Full documentation](http://rubydoc.info/gems/elasticsearch-extensions/Elasticsearch/Extensions/Test/StartupShutdown)

Examples in the Elasticsearch gem test suite: [1](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/test/integration/client_test.rb#L4-L6), [2](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/test/test_helper.rb#L44)

### Test::Profiling

Allows to define and execute profiling tests within [Shoulda](https://github.com/thoughtbot/shoulda) contexts.
Measures operations and reports statistics, including code profile.

Let's define a simple profiling test in a `profiling_test.rb` file:

    require 'test/unit'
    require 'shoulda/context'
    require 'elasticsearch/extensions/test/profiling'

    class ProfilingTest < Test::Unit::TestCase
      extend Elasticsearch::Extensions::Test::Profiling

      context "Mathematics" do
        measure "divide numbers", count: 10_000 do
          assert_nothing_raised { 1/2 }
        end
      end

    end

Let's run it:

    $ QUIET=y ruby profiling_test.rb

    ...
    ProfilingTest

    -------------------------------------------------------------------------------
    Context: Mathematics should divide numbers (10000x)
    mean: 0.03ms | avg: 0.03ms | max: 0.14ms
    -------------------------------------------------------------------------------
         PASS (0:00:00.490) test: Mathematics should divide numbers (10000x).
    ...

When using the `QUIET` option, only the statistics on operation throughput are printed.
When omitted, the full code profile by [RubyProf](https://github.com/ruby-prof/ruby-prof) is printed.

[Full documentation](http://rubydoc.info/gems/elasticsearch-extensions/Elasticsearch/Extensions/Test/StartupShutdown)

[Example in the Elasticsearch gem](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/test/profile/client_benchmark_test.rb)


## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elasticsearch-extensions

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elasticsearch-extensions', git: 'git://github.com/elasticsearch/elasticsearch-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elasticsearch/elasticsearch-ruby.git
    cd elasticsearch-ruby/elasticsearch-extensions
    bundle install
    rake install

## License

This software is licensed under the Apache 2 license, quoted below.

    Copyright (c) 2013 Elasticsearch <http://www.elasticsearch.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

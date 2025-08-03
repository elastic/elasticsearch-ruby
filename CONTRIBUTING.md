# Contributing to Elasticsearch Ruby

This guide assumes Ruby is already installed. We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/). So we can't guarantee the code works for versions of Ruby that have reached their end of life.

To work on the code, clone and bootstrap the project first:

```
$ git clone https://github.com/elasticsearch/elasticsearch-ruby.git
$ cd elasticsearch-ruby/
$ bundle exec rake bundle
```

This will run `bundle install` in all subprojects.

# Interactive shell

You can run the client code right away in a Interactive Ruby Shell by running the following command from the project's root directory:
```
$ rake console # calls ./elasticsearch/bin/elastic_ruby_console
[1] elastic_ruby(main)> client = Elasticsearch::Client.new(host: 'http://elastic:changeme@localhost:9200', log: true)
[2] elastic_ruby(main)> client.info
```

This will use either `irb` or `pry` and load the `elasticsearch` and `elasticsearch-api` gems into the shell.

# Tests

To run the tests, you need to start a testing cluster on port 9200. We suggest using Docker, there's a Rake task to start a testing cluster in a Docker container. You need to use a value for `VERSION` that matches a version string from our [artifacts API](https://artifacts-api.elastic.co/v1/versions):

```
rake docker:start[VERSION]
```

E.g.: `rake docker:start[9.0.0-SNAPSHOT]`.
To start the container with Platinum, pass it in as a parameter: `rake docker:start[8.x-SNAPSHOT,platinum]`.

There's another rake task that will read the STACK_VERSION value from `.buildkite/pipeline.yml` and run that version of Elasticsearch: `rake es:up`.

If you get this error when running the script:
```
max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]
```
Check [this link](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#_set_vm_max_map_count_to_at_least_262144) for instructions on how to fix it.

You can also use [start-local](https://github.com/elastic/start-local), which can run Elasticsearch and Kibana locally for development/testing. You only need to run Elasticsearch (`-esonly`) for development purposes, and you can specify a version with the `-v` parameter:

```bash
curl -fsSL https://elastic.co/start-local | sh -s -- -esonly -v 9.0.0
```

As mentioned, the tests will atempt to run against `http://localhost:9200` by default. We provide the Docker task for the test cluster and recommend using it. But you can provide a different test server of your own. If you're using a different host or port, set the `TEST_ES_SERVER` environment variable with the server information. E.g.:

```
$ TEST_ES_SERVER='http://localhost:9250' be rake test:client
```

To run all the tests in all the subprojects, use the Rake task:

```
rake test:client
```

# Elasticsearch Rest API Tests

The integration tests on this project run the [Elasticsearch Client tests](https://github.com/elastic/elasticsearch-clients-tests/) with the [Elasticsearch Tests Runner](https://github.com/elastic/es-test-runner-ruby/) library. This runs in CI against an Elasticsearch cluster in Docker. The [Elasticsearch's REST API Spec tests](https://github.com/elastic/elasticsearch/tree/main/rest-api-spec/src/main/resources/rest-api-spec/test#test-suite) can still be ran following [these instructions](https://github.com/elastic/elasticsearch-ruby/tree/main/elasticsearch-api/api-spec-testing#readme).

You can run the yaml API tests with:

```
rake test:yaml
```

Check `rake -T` for more test tasks.

# Contributing

The process for contributing to any of the [Elasticsearch](https://github.com/elasticsearch) repositories is similar:

1. It is best to do your work in a separate Git branch. This makes it easier to synchronise your changes with [`rebase`](http://mislav.uniqpath.com/2013/02/merge-vs-rebase/).

2. Make sure your changes don't break any existing tests, and that you add tests for both bugfixes and new functionality. If you want to examine the test coverage, you can generate a report by running `COVERAGE=true rake test:all`.

3. **Sign the contributor license agreement.**
Please make sure you have signed the [Contributor License Agreement](https://www.elastic.co/contributor-agreement/). We are not asking you to assign copyright to us, but to give us the right to distribute your code without restriction. We ask this of all contributors in order to assure our users of the origin and continuing existence of the code. You only need to sign the CLA once.

4. Submit a pull request.
Push your local changes to your forked copy of the repository and submit a pull request. In the pull request, describe what your changes do and mention the number of the issue where discussion has taken place, eg “Closes #123″.


Let me know if you'd like a version optimized for a README file, website docs, or to convert this into a CLI tool helper!

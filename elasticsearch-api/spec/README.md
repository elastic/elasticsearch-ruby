# Rest API YAML Spec Runner

The file that traverses the yaml files and loads a **TestFile** object per each of them:
`elasticsearch-api/spec/elasticsearch/api/rest_api_yaml_spec.rb`

You can use the SINGLE_TEST env variable to run just one test, or add code like this on the first line of the tests.each block:  
```ruby
next unless file =~ /indices.put_mapping\/all_path_options_with_types.yml/
```

#### TestFile object
Class representing a single test file. Contains setup, teardown and tests.   
`../api-spec-testing/test_file.rb`

#### Test object
Every single test in the test file is represented in the Test object.   
`../api-spec-testing/test_file/test.rb`

#### TaskGroup objects

Tests are ordered in task groups, an array of TaskGroup objects.  
`../api-spec-testing/test_file/task_group.rb`  

Task Groups are a representation of a block of actions consisting of 'do' actions and their verifications. e.g.: 
```yaml
 - do:
      index:
          index:  test-index
          id:     1
          body:   { foo: bar }

 - match:   { _index:   test-index }
 - match:   { _id:      "1"}
 - match:   { _version: 1}
```

**Before** each test, the spec runner runs `clear_data` on the test_file. This clears indices, index templates, snapshots and repositories. For xpack it also clears roles, users, privileges, datafeeds, ml_jobs and more.

**After** each test, it runs the test file teardown and `clear_data` again.

For each TaskGroup, it sees what's in the task group definition and runs an expectation test.

# Rest YAML tests Helper

`elasticsearch-api/spec/rest_yaml_tests_helper.rb`

- `ADMIN_CLIENT` is defined here.
- `SINGLE_TEST` is defined here.
- Skipped tests are listed here

# Spec Helper

- `DEFAULT_CLIENT` is defined here

# RSpec Matchers

The tests use custom [RSpec Matchers](https://www.rubydoc.info/gems/rspec-expectations/RSpec/Matchers) defined in `api-spec-testing/rspec_matchers.rb`.

# Enable Logging

To enable logging, set the environment `QUIET` to false before running the tests. In CI, this is located in the [Dockerfile](https://github.com/elastic/elasticsearch-ruby/blob/master/.ci/Dockerfile). The environment variable is evaluated in the Rest YAML tests Helper file.

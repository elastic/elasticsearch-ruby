# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# Match the `length` of a field.
RSpec::Matchers.define :match_response_field_length do |expected_pairs, test|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      # ssl test returns results at '$body' key. See ssl/10_basic.yml
      expected_pairs = expected_pairs['$body'] if expected_pairs['$body']

      expected_key = test.inject_master_node_id(expected_key)
      split_key = TestFile::Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key] || _response[key.to_s]
        end
      end
      actual_value.size == expected_value
    end
  end
end

# Validate that a field is `true`.
RSpec::Matchers.define :match_true_field do |field, test|

  match do |response|
    # Handle is_true: ''
    return !!response if field == ''
    split_key = TestFile::Test.split_and_parse_key(field).collect { |k| test.get_cached_value(k) }
    !!TestFile::Test.find_value_in_document(split_key, response)
  end
end

# Validate that a field is `false`.
RSpec::Matchers.define :match_false_field do |field, test|

  match do |response|
    # Handle is_false: ''
    return !response if field == ''
    split_key = TestFile::Test.split_and_parse_key(field).collect { |k| test.get_cached_value(k) }
    value_in_doc = TestFile::Test.find_value_in_document(split_key, response)
    value_in_doc == 0 || !value_in_doc
  end
end

# Validate that a field is `gte` than a given value.
RSpec::Matchers.define :match_gte_field do |expected_pairs, test|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      expected_key = test.inject_master_node_id(expected_key)
      split_key = TestFile::Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|

        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key] || _response[key]
        end
      end
      actual_value >= test.get_cached_value(expected_value)
    end
  end
end

# Validate that a field is `gt` than a given value.
RSpec::Matchers.define :match_gt_field do |expected_pairs, test|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      expected_key = test.inject_master_node_id(expected_key)
      split_key = TestFile::Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key] || _response[key.to_s]
        end
      end
      actual_value > test.get_cached_value(expected_value)
    end
  end
end

# Validate that a field is `lte` than a given value.
RSpec::Matchers.define :match_lte_field do |expected_pairs, test|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      expected_key = test.inject_master_node_id(expected_key)
      split_key = TestFile::Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key] || _response[key.to_s]
        end
      end
      actual_value <= test.get_cached_value(expected_value)
    end
  end
end

# Validate that a field is `lt` than a given value.
RSpec::Matchers.define :match_lt_field do |expected_pairs, test|

  match do |response|
    expected_pairs.all? do |expected_key, expected_value|

      expected_key = test.inject_master_node_id(expected_key)
      split_key = TestFile::Test.split_and_parse_key(expected_key)

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key] || _response[key.to_s]
        end
      end
      actual_value < test.get_cached_value(expected_value)
    end
  end
end

# Match an arbitrary field of a response to a given value.
RSpec::Matchers.define :match_response do |expected_pairs, test|

  match do |response|

    # sql test returns results at '$body' key. See sql/translate.yml
    expected_pairs = expected_pairs['$body'] if expected_pairs['$body']

    # sql test has a String response. See sql/sql.yml
    if expected_pairs.is_a?(String)
      return compare_string_response(response, expected_pairs)
    end

    expected_pairs.all? do |expected_key, expected_value|

      # See test xpack/10_basic.yml
      # The master node id must be injected in the keys of match clauses
      expected_key = test.inject_master_node_id(expected_key)

      split_key = TestFile::Test.split_and_parse_key(expected_key)
      actual_value = TestFile::Test.find_value_in_document(split_key, response)

      # Sometimes the expected value is a cached value from a previous request.
      # See test api_key/10_basic.yml
      expected_value = test.get_cached_value(expected_value)

      # When you must match a regex. For example:
      #   match: {task: '/.+:\d+/'}
      if expected_value.is_a?(String) && expected_value[0] == "/" && expected_value[-1] == "/"
        /#{expected_value.tr("/", "")}/ =~ actual_value
      elsif expected_key == ''
        expected_value == response
      else
        actual_value == expected_value
      end
    end
  end

  def compare_string_response(response, expected_string)
    regexp = Regexp.new(expected_string.strip[1..-2], Regexp::EXTENDED|Regexp::MULTILINE)
    regexp =~ response
  end
end

# Match that a request returned a given error.
RSpec::Matchers.define :match_error do |expected_error|

  match do |actual_error|
    # Remove surrounding '/' in string representing Regex
    expected_error = expected_error.chomp("/")
    expected_error = expected_error[1..-1] if expected_error =~ /^\//
    message = actual_error.message.tr("\\","")

    case expected_error
    when 'request_timeout'
      message =~ /\[408\]/
    when 'missing'
      message =~ /\[404\]/
    when 'conflict'
      message =~ /\[409\]/
    when 'request'
      message =~ /\[500\]/
    when 'bad_request'
      message =~ /\[400\]/
    when 'param'
      message =~ /\[400\]/ ||
          actual_error.is_a?(ArgumentError)
    when 'unauthorized'
      actual_error.is_a?(Elasticsearch::Transport::Transport::Errors::Unauthorized)
    when 'forbidden'
      actual_error.is_a?(Elasticsearch::Transport::Transport::Errors::Forbidden)
    else
      message =~ /#{expected_error}/
    end
  end
end

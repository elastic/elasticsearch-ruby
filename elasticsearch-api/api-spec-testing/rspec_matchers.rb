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

# Match the `length` of a field.
RSpec::Matchers.define :match_response_field_length do |expected_pairs, test|
  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      # ssl test returns results at '$body' key. See ssl/10_basic.yml
      expected_pairs = expected_pairs['$body'] if expected_pairs['$body']

      split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
        test.get_cached_value(k)
      end

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
    # TODO: Refactor! split_key for is_true
    if (match = field.match(/(^\$[a-z]+)/))
      keys = field.split('.')
      keys.delete(match[1])
      dynamic_key = test.cached_values[match[1].gsub('$', '')]
      return !!dynamic_key.dig(*keys)
    end

    # Handle is_true: ''
    return !!response if field == ''

    split_key = TestFile::Test.split_and_parse_key(field).collect do |k|
      test.get_cached_value(k)
    end
    !!TestFile::Test.find_value_in_document(split_key, response)
  end

  failure_message do |response|
    "the response `#{response}` does not have `true` in the field `#{field}`"
  end
end

# Validate that a field is `false`.
RSpec::Matchers.define :match_false_field do |field, test|
  match do |response|
    # Handle is_false: ''
    return !response if field == ''
    split_key = TestFile::Test.split_and_parse_key(field).collect do |k|
      test.get_cached_value(k)
    end
    value_in_doc = TestFile::Test.find_value_in_document(split_key, response)
    value_in_doc == 0 || !value_in_doc
  end

  failure_message do |response|
    "the response `#{response}` does not have `false` in the field `#{field}`"
  end
end

# Validate that a field is `gte` than a given value.
RSpec::Matchers.define :match_gte_field do |expected_pairs, test|
  match do |response|
    expected_pairs.all? do |expected_key, expected_value|
      split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
        test.get_cached_value(k)
      end

      actual_value = split_key.inject(response) do |_response, key|
        # If the key is an index, indicating element of a list
        if _response.empty? && key == '$body'
          _response
        else
          _response[key] || _response[key.to_s]
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
      split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
        test.get_cached_value(k)
      end

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
      split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
        test.get_cached_value(k)
      end

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
      split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
        test.get_cached_value(k)
      end

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
RSpec::Matchers.define :match_response do |pairs, test|
  match do |response|
    pairs = sanitize_pairs(pairs)
    compare_pairs(pairs, response, test).empty?
  end

  failure_message do |response|
    "the expected response pair/value(s) #{@mismatched_pairs}" +
        " does not match the pair/value(s) in the response #{response}"
  end

  def sanitize_pairs(expected_pairs)
    # sql test returns results at '$body' key. See sql/translate.yml
    @pairs ||= expected_pairs['$body'] ? expected_pairs['$body'] : expected_pairs
  end

  def compare_pairs(expected_pairs, response, test)
    @mismatched_pairs = {}
    if expected_pairs.is_a?(String)
      @mismatched_pairs = expected_pairs unless compare_string_response(expected_pairs, response)
    else
      compare_hash(expected_pairs, response, test)
    end
    @mismatched_pairs
  end

  def compare_hash(expected_pairs, actual_hash, test)
    expected_pairs.each do |expected_key, expected_value|
      # TODO: Refactor! split_key
      if (match = expected_key.match(/(^\$[a-z]+)/))
        keys = expected_key.split('.')
        keys.delete(match[1])
        dynamic_key = test.cached_values[match[1].gsub('$', '')]
        value = dynamic_key.dig(*keys)

        if expected_pairs.values.first.is_a?(String) && expected_pairs.values.first.match?(/^\$/)
          return test.cached_values[expected_pairs.values.first.gsub('$','')] == value
        else
          return expected_pairs.values.first == value
        end

      else
        split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
          # Sometimes the expected *key* is a cached value from a previous request.
          test.get_cached_value(k)
        end
      end
      # We now accept 'nested.keys' so let's try the previous implementation and if that doesn't
      # work, try with the nested key, otherwise, raise exception.
      begin
        actual_value = TestFile::Test.find_value_in_document(split_key, actual_hash)
      rescue TypeError => e
        actual_value = TestFile::Test.find_value_in_document(expected_key, actual_hash)
      rescue StandardError => e
        raise e
      end
      # When the expected_key is ''
      actual_value = actual_hash if split_key.empty?
      # Sometimes the key includes dots. See watcher/put_watch/60_put_watch_with_action_condition.yml
      actual_value = TestFile::Test.find_value_in_document(expected_key, actual_hash) if actual_value.nil?

      # Sometimes the expected *value* is a cached value from a previous request.
      # See test api_key/10_basic.yml
      expected_value = test.get_cached_value(expected_value)

      case expected_value
      when Hash
        compare_hash(expected_value, actual_value, test)
      when Array
        unless compare_array(expected_value, actual_value, test, actual_hash)
          @mismatched_pairs.merge!(expected_key => expected_value)
        end
      when String
        unless compare_string(expected_value, actual_value, test, actual_hash)
          @mismatched_pairs.merge!(expected_key => expected_value)
        end
      when Time
        compare_string(expected_value.to_s, Time.new(actual_value).to_s, test, actual_hash)
      else
        unless expected_value == actual_value
          @mismatched_pairs.merge!(expected_key => expected_value)
        end
      end
    end
  end

  def compare_string(expected, actual_value, test, response)
    # When you must match a regex. For example:
    #   match: {task: '/.+:\d+/'}
    if expected[0] == '/' && expected[-1] == '/'
      parsed = expected
      expected.scan(/\$\{([a-z_0-9]+)\}/) do |match|
        parsed = parsed.gsub(/\$\{?#{match.first}\}?/, test.cached_values[match.first])
      end
      /#{parsed.tr("/", "")}/ =~ actual_value
    elsif !!(expected.match?(/^-?[0-9]{1}\.[0-9]+E[0-9]+/))
      # When the value in the yaml test is a big number, the format is
      # different from what Ruby uses, so we try different options:
      actual_value.to_s == expected.gsub('E', 'e+') || # transform  X.XXXXEXX to X.XXXXXe+XX to compare thme
        actual_value == expected || # compare the actual values
        expected.to_f.to_s == actual_value.to_f.to_s # transform both to Float and compare them
    elsif expected == '' && actual_value != ''
      actual_value == response
    else
      expected == actual_value
    end
  end

  def compare_array(expected, actual, test, response)
    expected.each_with_index do |value, i|
      case value
      when Hash
        return false unless compare_hash(value, actual[i], test)
      when Array
        return false unless compare_array(value, actual[i], test, response)
      when String
        return false unless compare_string(value, actual[i], test, response)
      end
    end
  end

  def compare_string_response(expected_string, response)
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

    message = actual_error.message.tr('\\', '')

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
      actual_error.is_a?(Elastic::Transport::Transport::Errors::Unauthorized)
    when 'forbidden'
      actual_error.is_a?(Elastic::Transport::Transport::Errors::Forbidden)
    when /error parsing field/, /illegal_argument_exception/
      message =~ /\[400\]/ ||
        actual_error.is_a?(Elastic::Transport::Transport::Errors::BadRequest)
    when /NullPointerException/
      message =~ /\[400\]/
    else
      message =~ /#{expected_error}/
    end
  end

  failure_message do |actual_error|
    "the error `#{actual_error}` does not match the expected error `#{expected_error}`"
  end
end

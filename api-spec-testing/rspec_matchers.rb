# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
    # Handle is_true: ''
    return !!response if field == ''

    split_key = TestFile::Test.split_and_parse_key(field).collect do |k|
      test.get_cached_value(k)
    end
    !!TestFile::Test.find_value_in_document(split_key, response)
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
RSpec::Matchers.define :match_response do |expected_pairs, test|

  match do |response|
    mismatched_values(sanitize_pairs(expected_pairs), test, response).empty?
  end

  failure_message do |response|
    "the pair/value #{mismatched_values(sanitize_pairs(expected_pairs), test, response)}" +
        " does not match the pair/value in the response #{response}"
  end

  def sanitize_pairs(expected_pairs)
    # sql test returns results at '$body' key. See sql/translate.yml
    @pairs ||= expected_pairs['$body'] ? expected_pairs['$body'] : expected_pairs
  end

  def mismatched_values(pairs, test, response)
    @mismatched_values ||= begin
      if pairs.is_a?(String)
        # Must return an empty list if there are no mismatched values
        compare_string_response(pairs, response) ? [] : [ pairs ]
      else
        compare_hash(pairs, response, test)
      end
    end
  end

  def compare_hash(expected_keys_values, response, test)
    expected_keys_values.reject do |expected_key, expected_value|
      # Select the values that don't match, used for the failure message.

      if expected_value.is_a?(Hash)
        compare_hash(response[expected_key], expected_value, test)
      elsif expected_value.is_a?(String)
        split_key = TestFile::Test.split_and_parse_key(expected_key).collect do |k|
          test.get_cached_value(k)
        end
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

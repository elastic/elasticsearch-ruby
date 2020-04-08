# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Finds the structure of a text file. The text file must contain data that is suitable to be ingested into Elasticsearch.
          #
          # @option arguments [Int] :lines_to_sample How many lines of the file should be included in the analysis
          # @option arguments [Int] :line_merge_size_limit Maximum number of characters permitted in a single message when lines are merged to create messages.
          # @option arguments [Time] :timeout Timeout after which the analysis will be aborted
          # @option arguments [String] :charset Optional parameter to specify the character set of the file
          # @option arguments [String] :format Optional parameter to specify the high level file format
          #   (options: ndjson,xml,delimited,semi_structured_text)

          # @option arguments [Boolean] :has_header_row Optional parameter to specify whether a delimited file includes the column names in its first row
          # @option arguments [List] :column_names Optional parameter containing a comma separated list of the column names for a delimited file
          # @option arguments [String] :delimiter Optional parameter to specify the delimiter character for a delimited file - must be a single character
          # @option arguments [String] :quote Optional parameter to specify the quote character for a delimited file - must be a single character
          # @option arguments [Boolean] :should_trim_fields Optional parameter to specify whether the values between delimiters in a delimited file should have whitespace trimmed from them
          # @option arguments [String] :grok_pattern Optional parameter to specify the Grok pattern that should be used to extract fields from messages in a semi-structured text file
          # @option arguments [String] :timestamp_field Optional parameter to specify the timestamp field in the file
          # @option arguments [String] :timestamp_format Optional parameter to specify the timestamp format in the file - may be either a Joda or Java time format
          # @option arguments [Boolean] :explain Whether to include a commentary on how the structure was derived
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The contents of the file to be analyzed (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-find-file-structure.html
          #
          def find_file_structure(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/find_file_structure"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = Elasticsearch::API::Utils.__bulkify(arguments.delete(:body))
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:find_file_structure, [
            :lines_to_sample,
            :line_merge_size_limit,
            :timeout,
            :charset,
            :format,
            :has_header_row,
            :column_names,
            :delimiter,
            :quote,
            :should_trim_fields,
            :grok_pattern,
            :timestamp_field,
            :timestamp_format,
            :explain
          ].freeze)
      end
    end
    end
  end
end

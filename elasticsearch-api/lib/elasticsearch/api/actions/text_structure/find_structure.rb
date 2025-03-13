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
#
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module TextStructure
      module Actions
        # Find the structure of a text file.
        # The text file must contain data that is suitable to be ingested into Elasticsearch.
        # This API provides a starting point for ingesting data into Elasticsearch in a format that is suitable for subsequent use with other Elastic Stack functionality.
        # Unlike other Elasticsearch endpoints, the data that is posted to this endpoint does not need to be UTF-8 encoded and in JSON format.
        # It must, however, be text; binary text formats are not currently supported.
        # The size is limited to the Elasticsearch HTTP receive buffer size, which defaults to 100 Mb.
        # The response from the API contains:
        # * A couple of messages from the beginning of the text.
        # * Statistics that reveal the most common values for all fields detected within the text and basic numeric statistics for numeric fields.
        # * Information about the structure of the text, which is useful when you write ingest configurations to index it or similarly formatted text.
        # * Appropriate mappings for an Elasticsearch index, which you could use to ingest the text.
        # All this information can be calculated by the structure finder with no guidance.
        # However, you can optionally override some of the decisions about the text structure by specifying one or more query parameters.
        #
        # @option arguments [String] :charset The text's character set.
        #  It must be a character set that is supported by the JVM that Elasticsearch uses.
        #  For example, +UTF-8+, +UTF-16LE+, +windows-1252+, or +EUC-JP+.
        #  If this parameter is not specified, the structure finder chooses an appropriate character set.
        # @option arguments [String] :column_names If you have set format to +delimited+, you can specify the column names in a comma-separated list.
        #  If this parameter is not specified, the structure finder uses the column names from the header row of the text.
        #  If the text does not have a header role, columns are named "column1", "column2", "column3", for example.
        # @option arguments [String] :delimiter If you have set +format+ to +delimited+, you can specify the character used to delimit the values in each row.
        #  Only a single character is supported; the delimiter cannot have multiple characters.
        #  By default, the API considers the following possibilities: comma, tab, semi-colon, and pipe (+|+).
        #  In this default scenario, all rows must have the same number of fields for the delimited format to be detected.
        #  If you specify a delimiter, up to 10% of the rows can have a different number of columns than the first row.
        # @option arguments [String] :ecs_compatibility The mode of compatibility with ECS compliant Grok patterns.
        #  Use this parameter to specify whether to use ECS Grok patterns instead of legacy ones when the structure finder creates a Grok pattern.
        #  Valid values are +disabled+ and +v1+.
        #  This setting primarily has an impact when a whole message Grok pattern such as +%{CATALINALOG}+ matches the input.
        #  If the structure finder identifies a common structure but has no idea of meaning then generic field names such as +path+, +ipaddress+, +field1+, and +field2+ are used in the +grok_pattern+ output, with the intention that a user who knows the meanings rename these fields before using it. Server default: disabled.
        # @option arguments [Boolean] :explain If this parameter is set to +true+, the response includes a field named explanation, which is an array of strings that indicate how the structure finder produced its result.
        #  If the structure finder produces unexpected results for some text, use this query parameter to help you determine why the returned structure was chosen.
        # @option arguments [String] :format The high level structure of the text.
        #  Valid values are +ndjson+, +xml+, +delimited+, and +semi_structured_text+.
        #  By default, the API chooses the format.
        #  In this default scenario, all rows must have the same number of fields for a delimited format to be detected.
        #  If the format is set to +delimited+ and the delimiter is not set, however, the API tolerates up to 5% of rows that have a different number of columns than the first row.
        # @option arguments [String] :grok_pattern If you have set +format+ to +semi_structured_text+, you can specify a Grok pattern that is used to extract fields from every message in the text.
        #  The name of the timestamp field in the Grok pattern must match what is specified in the +timestamp_field+ parameter.
        #  If that parameter is not specified, the name of the timestamp field in the Grok pattern must match "timestamp".
        #  If +grok_pattern+ is not specified, the structure finder creates a Grok pattern.
        # @option arguments [Boolean] :has_header_row If you have set +format+ to +delimited+, you can use this parameter to indicate whether the column names are in the first row of the text.
        #  If this parameter is not specified, the structure finder guesses based on the similarity of the first row of the text to other rows.
        # @option arguments [Integer] :line_merge_size_limit The maximum number of characters in a message when lines are merged to form messages while analyzing semi-structured text.
        #  If you have extremely long messages you may need to increase this, but be aware that this may lead to very long processing times if the way to group lines into messages is misdetected. Server default: 10000.
        # @option arguments [Integer] :lines_to_sample The number of lines to include in the structural analysis, starting from the beginning of the text.
        #  The minimum is 2.
        #  If the value of this parameter is greater than the number of lines in the text, the analysis proceeds (as long as there are at least two lines in the text) for all of the lines.NOTE: The number of lines and the variation of the lines affects the speed of the analysis.
        #  For example, if you upload text where the first 1000 lines are all variations on the same message, the analysis will find more commonality than would be seen with a bigger sample.
        #  If possible, however, it is more efficient to upload sample text with more variety in the first 1000 lines than to request analysis of 100000 lines to achieve some variety. Server default: 1000.
        # @option arguments [String] :quote If you have set +format+ to +delimited+, you can specify the character used to quote the values in each row if they contain newlines or the delimiter character.
        #  Only a single character is supported.
        #  If this parameter is not specified, the default value is a double quote (+"+).
        #  If your delimited text format does not use quoting, a workaround is to set this argument to a character that does not appear anywhere in the sample.
        # @option arguments [Boolean] :should_trim_fields If you have set +format+ to +delimited+, you can specify whether values between delimiters should have whitespace trimmed from them.
        #  If this parameter is not specified and the delimiter is pipe (+|+), the default value is +true+.
        #  Otherwise, the default value is +false+.
        # @option arguments [Time] :timeout The maximum amount of time that the structure analysis can take.
        #  If the analysis is still running when the timeout expires then it will be stopped. Server default: 25s.
        # @option arguments [String] :timestamp_field The name of the field that contains the primary timestamp of each record in the text.
        #  In particular, if the text were ingested into an index, this is the field that would be used to populate the +@timestamp+ field.If the +format+ is +semi_structured_text+, this field must match the name of the appropriate extraction in the +grok_pattern+.
        #  Therefore, for semi-structured text, it is best not to specify this parameter unless +grok_pattern+ is also specified.For structured text, if you specify this parameter, the field must exist within the text.If this parameter is not specified, the structure finder makes a decision about which field (if any) is the primary timestamp field.
        #  For structured text, it is not compulsory to have a timestamp in the text.
        # @option arguments [String] :timestamp_format The Java time format of the timestamp field in the text.Only a subset of Java time format letter groups are supported:
        #  - +a+
        #  - +d+
        #  - +dd+
        #  - +EEE+
        #  - +EEEE+
        #  - +H+
        #  - +HH+
        #  - +h+
        #  - +M+
        #  - +MM+
        #  - +MMM+
        #  - +MMMM+
        #  - +mm+
        #  - +ss+
        #  - +XX+
        #  - +XXX+
        #  - +yy+
        #  - +yyyy+
        #  - +zzz+
        #  Additionally +S+ letter groups (fractional seconds) of length one to nine are supported providing they occur after +ss+ and separated from the +ss+ by a +.+, +,+ or +:+.
        #  Spacing and punctuation is also permitted with the exception of +?+, newline and carriage return, together with literal text enclosed in single quotes.
        #  For example, +MM/dd HH.mm.ss,SSSSSS 'in' yyyy+ is a valid override format.One valuable use case for this parameter is when the format is semi-structured text, there are multiple timestamp formats in the text, and you know which format corresponds to the primary timestamp, but you do not want to specify the full +grok_pattern+.
        #  Another is when the timestamp format is one that the structure finder does not consider by default.If this parameter is not specified, the structure finder chooses the best format from a built-in set.If the special value +null+ is specified the structure finder will not look for a primary timestamp in the text.
        #  When the format is semi-structured text this will result in the structure finder treating the text as single-line messages.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body text_files
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-text-structure-find-structure
        #
        def find_structure(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'text_structure.find_structure' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_text_structure/find_structure'
          params = Utils.process_params(arguments)

          payload = if body.is_a? Array
                      Elasticsearch::API::Utils.bulkify(body)
                    else
                      body
                    end

          headers.merge!('Content-Type' => 'application/x-ndjson')
          Elasticsearch::API::Response.new(
            perform_request(method, path, params, payload, headers, request_opts)
          )
        end
      end
    end
  end
end

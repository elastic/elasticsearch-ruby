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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Cat
      module Actions
        # Get anomaly detection jobs
        #
        # @option arguments [String] :job_id The ID of the jobs stats to fetch
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no jobs. (This includes `_all` string or when no jobs have been specified)
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, kb, mb, gb, tb, pb)
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [List] :h Comma-separated list of column names to display (options: assignment_explanation, buckets.count, buckets.time.exp_avg, buckets.time.exp_avg_hour, buckets.time.max, buckets.time.min, buckets.time.total, data.buckets, data.earliest_record, data.empty_buckets, data.input_bytes, data.input_fields, data.input_records, data.invalid_dates, data.last, data.last_empty_bucket, data.last_sparse_bucket, data.latest_record, data.missing_fields, data.out_of_order_timestamps, data.processed_fields, data.processed_records, data.sparse_buckets, forecasts.memory.avg, forecasts.memory.max, forecasts.memory.min, forecasts.memory.total, forecasts.records.avg, forecasts.records.max, forecasts.records.min, forecasts.records.total, forecasts.time.avg, forecasts.time.max, forecasts.time.min, forecasts.time.total, forecasts.total, id, model.bucket_allocation_failures, model.by_fields, model.bytes, model.bytes_exceeded, model.categorization_status, model.categorized_doc_count, model.dead_category_count, model.failed_category_count, model.frequent_category_count, model.log_time, model.memory_limit, model.memory_status, model.over_fields, model.partition_fields, model.rare_category_count, model.timestamp, model.total_category_count, node.address, node.ephemeral_id, node.id, node.name, opened_time, state)
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by (options: assignment_explanation, buckets.count, buckets.time.exp_avg, buckets.time.exp_avg_hour, buckets.time.max, buckets.time.min, buckets.time.total, data.buckets, data.earliest_record, data.empty_buckets, data.input_bytes, data.input_fields, data.input_records, data.invalid_dates, data.last, data.last_empty_bucket, data.last_sparse_bucket, data.latest_record, data.missing_fields, data.out_of_order_timestamps, data.processed_fields, data.processed_records, data.sparse_buckets, forecasts.memory.avg, forecasts.memory.max, forecasts.memory.min, forecasts.memory.total, forecasts.records.avg, forecasts.records.max, forecasts.records.min, forecasts.records.total, forecasts.time.avg, forecasts.time.max, forecasts.time.min, forecasts.time.total, forecasts.total, id, model.bucket_allocation_failures, model.by_fields, model.bytes, model.bytes_exceeded, model.categorization_status, model.categorized_doc_count, model.dead_category_count, model.failed_category_count, model.frequent_category_count, model.log_time, model.memory_limit, model.memory_status, model.over_fields, model.partition_fields, model.rare_category_count, model.timestamp, model.total_category_count, node.address, node.ephemeral_id, node.id, node.name, opened_time, state)
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/cat-anomaly-detectors.html
        #
        def ml_jobs(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.ml_jobs' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _job_id
                     "_cat/ml/anomaly_detectors/#{Utils.__listify(_job_id)}"
                   else
                     '_cat/ml/anomaly_detectors'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

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
    module Actions
      # Open a point in time.
      # A search request by default runs against the most recent visible data of the target indices,
      # which is called point in time. Elasticsearch pit (point in time) is a lightweight view into the
      # state of the data as it existed when initiated. In some cases, it’s preferred to perform multiple
      # search requests using the same point in time. For example, if refreshes happen between
      # +search_after+ requests, then the results of those requests might not be consistent as changes happening
      # between searches are only visible to the more recent point in time.
      # A point in time must be opened explicitly before being used in search requests.
      # A subsequent search request with the +pit+ parameter must not specify +index+, +routing+, or +preference+ values as these parameters are copied from the point in time.
      # Just like regular searches, you can use +from+ and +size+ to page through point in time search results, up to the first 10,000 hits.
      # If you want to retrieve more hits, use PIT with +search_after+.
      # IMPORTANT: The open point in time request and each subsequent search request can return different identifiers; always use the most recently received ID for the next search request.
      # When a PIT that contains shard failures is used in a search request, the missing are always reported in the search response as a +NoShardAvailableActionException+ exception.
      # To get rid of these exceptions, a new PIT needs to be created so that shards missing from the previous PIT can be handled, assuming they become available in the meantime.
      # **Keeping point in time alive**
      # The +keep_alive+ parameter, which is passed to a open point in time request and search request, extends the time to live of the corresponding point in time.
      # The value does not need to be long enough to process all data — it just needs to be long enough for the next request.
      # Normally, the background merge process optimizes the index by merging together smaller segments to create new, bigger segments.
      # Once the smaller segments are no longer needed they are deleted.
      # However, open point-in-times prevent the old segments from being deleted since they are still in use.
      # TIP: Keeping older segments alive means that more disk space and file handles are needed.
      # Ensure that you have configured your nodes to have ample free file handles.
      # Additionally, if a segment contains deleted or updated documents then the point in time must keep track of whether each document in the segment was live at the time of the initial search request.
      # Ensure that your nodes have sufficient heap space if you have many open point-in-times on an index that is subject to ongoing deletes or updates.
      # Note that a point-in-time doesn't prevent its associated indices from being deleted.
      # You can check how many point-in-times (that is, search contexts) are open with the nodes stats API.
      #
      # @option arguments [String, Array] :index A comma-separated list of index names to open point in time; use +_all+ or empty string to perform the operation on all indices (*Required*)
      # @option arguments [Time] :keep_alive Extend the length of time that the point in time persists. (*Required*)
      # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  By default, it is random.
      # @option arguments [String] :routing A custom value that is used to route operations to a specific shard.
      # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
      #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
      #  It supports comma-separated values, such as +open,hidden+. Valid values are: +all+, +open+, +closed+, +hidden+, +none+. Server default: open.
      # @option arguments [Boolean] :allow_partial_search_results Indicates whether the point in time tolerates unavailable shards or shard failures when initially creating the PIT.
      #  If +false+, creating a point in time request when a shard is missing or unavailable will throw an exception.
      #  If +true+, the point in time will contain all the shards that are available at the time of the request.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-open-point-in-time
      #
      def open_point_in_time(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'open_point_in_time' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = "#{Utils.listify(_index)}/_pit"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end

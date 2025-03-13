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
    module Snapshot
      module Actions
        # Analyze a snapshot repository.
        # Analyze the performance characteristics and any incorrect behaviour found in a repository.
        # The response exposes implementation details of the analysis which may change from version to version.
        # The response body format is therefore not considered stable and may be different in newer versions.
        # There are a large number of third-party storage systems available, not all of which are suitable for use as a snapshot repository by Elasticsearch.
        # Some storage systems behave incorrectly, or perform poorly, especially when accessed concurrently by multiple clients as the nodes of an Elasticsearch cluster do. This API performs a collection of read and write operations on your repository which are designed to detect incorrect behaviour and to measure the performance characteristics of your storage system.
        # The default values for the parameters are deliberately low to reduce the impact of running an analysis inadvertently and to provide a sensible starting point for your investigations.
        # Run your first analysis with the default parameter values to check for simple problems.
        # If successful, run a sequence of increasingly large analyses until you encounter a failure or you reach a +blob_count+ of at least +2000+, a +max_blob_size+ of at least +2gb+, a +max_total_data_size+ of at least +1tb+, and a +register_operation_count+ of at least +100+.
        # Always specify a generous timeout, possibly +1h+ or longer, to allow time for each analysis to run to completion.
        # Perform the analyses using a multi-node cluster of a similar size to your production cluster so that it can detect any problems that only arise when the repository is accessed by many nodes at once.
        # If the analysis fails, Elasticsearch detected that your repository behaved unexpectedly.
        # This usually means you are using a third-party storage system with an incorrect or incompatible implementation of the API it claims to support.
        # If so, this storage system is not suitable for use as a snapshot repository.
        # You will need to work with the supplier of your storage system to address the incompatibilities that Elasticsearch detects.
        # If the analysis is successful, the API returns details of the testing process, optionally including how long each operation took.
        # You can use this information to determine the performance of your storage system.
        # If any operation fails or returns an incorrect result, the API returns an error.
        # If the API returns an error, it may not have removed all the data it wrote to the repository.
        # The error will indicate the location of any leftover data and this path is also recorded in the Elasticsearch logs.
        # You should verify that this location has been cleaned up correctly.
        # If there is still leftover data at the specified location, you should manually remove it.
        # If the connection from your client to Elasticsearch is closed while the client is waiting for the result of the analysis, the test is cancelled.
        # Some clients are configured to close their connection if no response is received within a certain timeout.
        # An analysis takes a long time to complete so you might need to relax any such client-side timeouts.
        # On cancellation the analysis attempts to clean up the data it was writing, but it may not be able to remove it all.
        # The path to the leftover data is recorded in the Elasticsearch logs.
        # You should verify that this location has been cleaned up correctly.
        # If there is still leftover data at the specified location, you should manually remove it.
        # If the analysis is successful then it detected no incorrect behaviour, but this does not mean that correct behaviour is guaranteed.
        # The analysis attempts to detect common bugs but it does not offer 100% coverage.
        # Additionally, it does not test the following:
        # * Your repository must perform durable writes. Once a blob has been written it must remain in place until it is deleted, even after a power loss or similar disaster.
        # * Your repository must not suffer from silent data corruption. Once a blob has been written, its contents must remain unchanged until it is deliberately modified or deleted.
        # * Your repository must behave correctly even if connectivity from the cluster is disrupted. Reads and writes may fail in this case, but they must not return incorrect results.
        # IMPORTANT: An analysis writes a substantial amount of data to your repository and then reads it back again.
        # This consumes bandwidth on the network between the cluster and the repository, and storage space and I/O bandwidth on the repository itself.
        # You must ensure this load does not affect other users of these systems.
        # Analyses respect the repository settings +max_snapshot_bytes_per_sec+ and +max_restore_bytes_per_sec+ if available and the cluster setting +indices.recovery.max_bytes_per_sec+ which you can use to limit the bandwidth they consume.
        # NOTE: This API is intended for exploratory use by humans. You should expect the request parameters and the response format to vary in future versions.
        # NOTE: Different versions of Elasticsearch may perform different checks for repository compatibility, with newer versions typically being stricter than older ones.
        # A storage system that passes repository analysis with one version of Elasticsearch may fail with a different version.
        # This indicates it behaves incorrectly in ways that the former version did not detect.
        # You must work with the supplier of your storage system to address the incompatibilities detected by the repository analysis API in any version of Elasticsearch.
        # NOTE: This API may not work correctly in a mixed-version cluster.
        # *Implementation details*
        # NOTE: This section of documentation describes how the repository analysis API works in this version of Elasticsearch, but you should expect the implementation to vary between versions. The request parameters and response format depend on details of the implementation so may also be different in newer versions.
        # The analysis comprises a number of blob-level tasks, as set by the +blob_count+ parameter and a number of compare-and-exchange operations on linearizable registers, as set by the +register_operation_count+ parameter.
        # These tasks are distributed over the data and master-eligible nodes in the cluster for execution.
        # For most blob-level tasks, the executing node first writes a blob to the repository and then instructs some of the other nodes in the cluster to attempt to read the data it just wrote.
        # The size of the blob is chosen randomly, according to the +max_blob_size+ and +max_total_data_size+ parameters.
        # If any of these reads fails then the repository does not implement the necessary read-after-write semantics that Elasticsearch requires.
        # For some blob-level tasks, the executing node will instruct some of its peers to attempt to read the data before the writing process completes.
        # These reads are permitted to fail, but must not return partial data.
        # If any read returns partial data then the repository does not implement the necessary atomicity semantics that Elasticsearch requires.
        # For some blob-level tasks, the executing node will overwrite the blob while its peers are reading it.
        # In this case the data read may come from either the original or the overwritten blob, but the read operation must not return partial data or a mix of data from the two blobs.
        # If any of these reads returns partial data or a mix of the two blobs then the repository does not implement the necessary atomicity semantics that Elasticsearch requires for overwrites.
        # The executing node will use a variety of different methods to write the blob.
        # For instance, where applicable, it will use both single-part and multi-part uploads.
        # Similarly, the reading nodes will use a variety of different methods to read the data back again.
        # For instance they may read the entire blob from start to end or may read only a subset of the data.
        # For some blob-level tasks, the executing node will cancel the write before it is complete.
        # In this case, it still instructs some of the other nodes in the cluster to attempt to read the blob but all of these reads must fail to find the blob.
        # Linearizable registers are special blobs that Elasticsearch manipulates using an atomic compare-and-exchange operation.
        # This operation ensures correct and strongly-consistent behavior even when the blob is accessed by multiple nodes at the same time.
        # The detailed implementation of the compare-and-exchange operation on linearizable registers varies by repository type.
        # Repository analysis verifies that that uncontended compare-and-exchange operations on a linearizable register blob always succeed.
        # Repository analysis also verifies that contended operations either succeed or report the contention but do not return incorrect results.
        # If an operation fails due to contention, Elasticsearch retries the operation until it succeeds.
        # Most of the compare-and-exchange operations performed by repository analysis atomically increment a counter which is represented as an 8-byte blob.
        # Some operations also verify the behavior on small blobs with sizes other than 8 bytes.
        #
        # @option arguments [String] :repository The name of the repository. (*Required*)
        # @option arguments [Integer] :blob_count The total number of blobs to write to the repository during the test.
        #  For realistic experiments, you should set it to at least +2000+. Server default: 100.
        # @option arguments [Integer] :concurrency The number of operations to run concurrently during the test. Server default: 10.
        # @option arguments [Boolean] :detailed Indicates whether to return detailed results, including timing information for every operation performed during the analysis.
        #  If false, it returns only a summary of the analysis.
        # @option arguments [Integer] :early_read_node_count The number of nodes on which to perform an early read operation while writing each blob.
        #  Early read operations are only rarely performed. Server default: 2.
        # @option arguments [Integer, String] :max_blob_size The maximum size of a blob to be written during the test.
        #  For realistic experiments, you should set it to at least +2gb+. Server default: 10mb.
        # @option arguments [Integer, String] :max_total_data_size An upper limit on the total size of all the blobs written during the test.
        #  For realistic experiments, you should set it to at least +1tb+. Server default: 1gb.
        # @option arguments [Float] :rare_action_probability The probability of performing a rare action such as an early read, an overwrite, or an aborted write on each blob. Server default: 0.02.
        # @option arguments [Boolean] :rarely_abort_writes Indicates whether to rarely cancel writes before they complete. Server default: true.
        # @option arguments [Integer] :read_node_count The number of nodes on which to read a blob after writing. Server default: 10.
        # @option arguments [Integer] :register_operation_count The minimum number of linearizable register operations to perform in total.
        #  For realistic experiments, you should set it to at least +100+. Server default: 10.
        # @option arguments [Integer] :seed The seed for the pseudo-random number generator used to generate the list of operations performed during the test.
        #  To repeat the same set of operations in multiple experiments, use the same seed in each experiment.
        #  Note that the operations are performed concurrently so might not always happen in the same order on each run.
        # @option arguments [Time] :timeout The period of time to wait for the test to complete.
        #  If no response is received before the timeout expires, the test is cancelled and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-repository-analyze
        #
        def repository_analyze(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.repository_analyze' }

          defined_params = [:repository].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _repository = arguments.delete(:repository)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.listify(_repository)}/_analyze"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end

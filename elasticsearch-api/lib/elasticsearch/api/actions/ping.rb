# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns whether the cluster is running.
      #

      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
      #
      def ping(arguments = {})
        arguments = arguments.clone

        method = HTTP_HEAD
        path   = ""
        params = {}

        body = nil
        begin
        perform_request(method, path, params, body).status == 200 ? true : false
        rescue Exception => e
          if e.class.to_s =~ /NotFound|ConnectionFailed/ || e.message =~ /Not *Found|404|ConnectionFailed/i
            false
          else
            raise e
          end
      end
      end
    end
    end
end

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

require 'base64'

module Elasticsearch
  module Transport
    # Methods for the Elastic meta header used by Cloud.
    # X-Elastic-Client-Meta HTTP header which is used by Elastic Cloud and can be disabled when
    # instantiating the Client with the :enable_meta_header parameter set to `false`.
    #
    module MetaHeader
      def set_meta_header
        return if @arguments[:enable_meta_header] == false

        service, version = meta_header_service_version

        meta_headers = {
          service.to_sym => version,
          rb: RUBY_VERSION,
          t: Elasticsearch::Transport::VERSION
        }
        meta_headers.merge!(meta_header_engine) if meta_header_engine
        meta_headers.merge!(meta_header_adapter) if meta_header_adapter

        add_header({ 'x-elastic-client-meta' => meta_headers.map { |k, v| "#{k}=#{v}" }.join(',') })
      end

      def meta_header_service_version
        if enterprise_search?
          Elastic::ENTERPRISE_SERVICE_VERSION
        elsif elasticsearch?
          Elastic::ELASTICSEARCH_SERVICE_VERSION
        elsif defined?(Elasticsearch::VERSION)
          [:es, client_meta_version(Elasticsearch::VERSION)]
        else
          [:es, client_meta_version(Elasticsearch::Transport::VERSION)]
        end
      end

      def enterprise_search?
        defined?(Elastic::ENTERPRISE_SERVICE_VERSION) &&
          called_from?('enterprise-search-ruby')
      end

      def elasticsearch?
        defined?(Elastic::ELASTICSEARCH_SERVICE_VERSION) &&
          called_from?('elasticsearch')
      end

      def called_from?(service)
        !caller.select { |c| c.match?(service) }.empty?
      end

      # We return the current version if it's a release, but if it's a pre/alpha/beta release we
      # return <VERSION_NUMBER>p
      #
      def client_meta_version(version)
        regexp = /^([0-9]+\.[0-9]+\.[0-9]+)(\.?[a-z0-9.-]+)?$/
        match = version.match(regexp)
        return "#{match[1]}p" if (match[2])

        version
      end

      def meta_header_engine
        case RUBY_ENGINE
        when 'ruby'
          {}
        when 'jruby'
          { jv: ENV_JAVA['java.version'], jr: JRUBY_VERSION }
        when 'rbx'
          { rbx: RUBY_VERSION }
        else
          { RUBY_ENGINE.to_sym => RUBY_VERSION }
        end
      end

      # This function tries to define the version for the Faraday adapter. If it hasn't been loaded
      # by the time we're calling this method, it's going to report the adapter (if we know it) but
      # return 0 as the version. It won't report anything when using a custom adapter we don't
      # identify.
      #
      # Returns a Hash<adapter_alias, version>
      #
      def meta_header_adapter
        if @transport_class == Transport::HTTP::Faraday
          version = '0'
          adapter_version = case @arguments[:adapter]
                   when :patron
                     version = Patron::VERSION if defined?(::Patron::VERSION)
                     {pt: version}
                   when :net_http
                     version = if defined?(Net::HTTP::VERSION)
                                 Net::HTTP::VERSION
                               elsif defined?(Net::HTTP::HTTPVersion)
                                 Net::HTTP::HTTPVersion
                               end
                     {nh: version}
                   when :typhoeus
                     version = Typhoeus::VERSION if defined?(::Typhoeus::VERSION)
                     {ty: version}
                   when :httpclient
                     version = HTTPClient::VERSION if defined?(HTTPClient::VERSION)
                     {hc: version}
                   when :net_http_persistent
                     version = Net::HTTP::Persistent::VERSION if defined?(Net::HTTP::Persistent::VERSION)
                     {np: version}
                   else
                     {}
                   end
          {fd: Faraday::VERSION}.merge(adapter_version)
        elsif defined?(Transport::HTTP::Curb) && @transport_class == Transport::HTTP::Curb
          {cl: Curl::CURB_VERSION}
        elsif defined?(Transport::HTTP::Manticore) && @transport_class == Transport::HTTP::Manticore
          {mc: Manticore::VERSION}
        end
      end
    end
  end
end

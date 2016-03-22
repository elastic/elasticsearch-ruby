module Elasticsearch
  module Transport
    module Transport
      module HTTP
        class Manticore
          class Pool
            attr_reader :logger

            class FatalURLError < StandardError; end

            def initialize(logger, adapter, urls=[], resurrect_interval=5)
              @logger = logger
              @state_mutex = Mutex.new
              @url_info = {}
              @adapter = adapter
              @stopping = false
              @resurrect_interval = resurrect_interval
              @resurrectionist = start_resurrectionist
              update_urls(urls)
            end

            def close
              stop_resurrectionist
              wait_for_open_connections
              @adapter.close
            end

            def wait_for_open_connections
              until open_connections == 0
                sleep 1
              end
            end

            def open_connections
              @state_mutex.synchronize { @url_info.values.map {|v| v[:open] }}
            end

            def start_resurrectionist
              Thread.new do
                slept_for = 0
                loop do
                  sleep 1
                  slept_for += 1

                  break if @state_mutex.synchronize { @stopping }

                  if slept_for >= @resurrect_interval
                    slept_for = 0
                    resurrect_dead!
                  end
                end
              end
            end

            def resurrect_dead!
              # Try to keep locking granularity low such that we don't affect IO...
              @state_mutex.synchronize { @url_info.select {|url,meta| meta[:dead] } }.each do |url,meta|
                begin
                  perform_request_to_url(url, "GET", "/")
                  # If no exception was raised it must have succeeded!
                  logger.info("Resurrected connection to dead ES instance at #{url}, got an error")
                  @state_mutex.synchronize { meta[:dead] = false }
                rescue FatalURLError => e
                  logger.debug("Attempted to resurrect connection to dead ES instance at #{url}, got an error [#{e.class}] #{e.message}")
                end
              end
            end

            def stop_resurrectionist
              @state_mutex.synchronize { @stopping = true }
              @resurrectionist.join # Wait for thread to stop
            end

            def perform_request(method, path, params={}, body=nil)
              with_connection do |url|
                [url, perform_request_to_url(url, method, path, params, body)]
              end
            end

            def perform_request_to_url(url, method, path, params={}, body=nil)
              raise ArgumentError, "No URL specified!" unless url

              @adapter.perform_request(url, method, path, params, body)
            rescue ::Manticore::Timeout,::Manticore::SocketException, ::Manticore::ClientProtocolException, ::Manticore::ResolutionFailure => e
              logger.error "[#{e.class}] #{e.message} #{url}" if logger
              raise FatalURLError, "Could not reach host #{e.class}: #{e.message}"
            end

            def update_urls(new_urls)
              @state_mutex.synchronize do
                # Add new connections
                new_urls.each do |url|
                  unless @url_info[url]
                    logger.info("Elasticsearch pool adding node @ URL #{url}") if logger
                    add_url(url)
                  end
                end

                # Delete connections not in the new list
                @url_info.each do |url,_|
                  unless new_urls.include?(url)
                    logger.info("Elasticsearch pool removing node @ URL #{url}") if logger
                    remove_url(url)
                  end
                end
              end
            end

            def add_url(url)
              @url_info[url] ||= empty_url_meta
            end

            def remove_url(url)
              @url_info.delete(url)
            end

            def empty_url_meta
              {
                :open => 0,
                :dead => false
              }
            end

            def with_connection
              url, url_meta = get_connection

              raise Error, "No Available connections!" unless url
              yield url
            rescue FatalURLError => e
              @state_mutex.synchronize do
                url_meta[:dead] = true
                url_meta[:last_error] = e
              end
              raise e
            ensure
              return_connection(url)
            end

            def get_connection
              @state_mutex.synchronize do
                # The goal here is to pick a random connection from the least-in-use connections
                # We want some randomness so that we don't hit the same node over and over, but
                # we also want more 'fair' behavior in the event of high concurrency
                raise "No available connections!" if @url_info.empty?

                eligible_set = nil
                lowest_value_seen = nil
                @url_info.each do |url,meta|
                  meta_open = meta[:open]
                  next if meta[:dead]

                  if lowest_value_seen.nil? || meta_open < lowest_value_seen
                    lowest_value_seen = meta_open
                    eligible_set = [[url, meta]]
                  elsif lowest_value_seen == meta_open
                    eligible_set << [url, meta]
                  end
                end

                return nil if eligible_set.nil?

                pick_and_meta = eligible_set.sample
                pick, pick_meta = pick_and_meta
                pick_meta[:open] += 1

                pick_and_meta
              end
            end

            def return_connection(url)
              @state_mutex.synchronize do
                if @url_info[url] # Guard against the condition where the connection has already been deleted
                  @url_info[url][:open] -= 1
                end
              end
            end
          end
        end
      end
    end
  end
end
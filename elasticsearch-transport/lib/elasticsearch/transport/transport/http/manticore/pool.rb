module Elasticsearch
  module Transport
    module Transport
      module HTTP
        class Manticore
          class Pool
            class NoConnectionAvailableError < Error; end

            attr_reader :logger

            def initialize(logger, adapter, healthcheck_path="/", urls=[], resurrect_interval=5, host_unreachable_exceptions=[])
              @logger = logger
              @state_mutex = Mutex.new
              @url_info = {}
              @adapter = adapter
              @healthcheck_path = healthcheck_path
              @stopping = false
              @resurrect_interval = resurrect_interval
              @resurrectionist = start_resurrectionist
              @host_unreachable_exceptions = host_unreachable_exceptions
              update_urls(urls)
            end

            def close
              logger.debug  "Stopping resurrectionist" if logger
              stop_resurrectionist
              logger.debug  "Waiting for in use manticore connections" if logger
              wait_for_in_use_connections
              logger.debug("Closing adapter #{@adapter}") if logger
              @adapter.close
            end

            def wait_for_in_use_connections
              until in_use_connections.empty?
                logger.info "Blocked on shutdown to in use connections #{@state_mutex.synchronize {@url_info}}" if logger
                sleep 1
              end
            end

            def in_use_connections
              @state_mutex.synchronize { @url_info.values.select {|v| v[:in_use] > 0 } }
            end

            def alive_urls_count
              @state_mutex.synchronize { @url_info.values.select {|v| !v[:dead] }.count }
            end

            def start_resurrectionist
              Thread.new do
                last_resurrect = Time.now
                until @state_mutex.synchronize { @stopping } do
                  if Time.now-last_resurrect >= @resurrect_interval
                    last_resurrect = Time.now
                    resurrect_dead!
                  end
                end
              end
            end

            def resurrect_dead!
              # Try to keep locking granularity low such that we don't affect IO...
              @state_mutex.synchronize { @url_info.select {|url,meta| meta[:dead] } }.each do |url,meta|
                begin
                  @logger.info("Checking url #{url} with path #{@healthcheck_path} to see if node resurrected")
                  perform_request_to_url(url, "GET", @healthcheck_path)
                  # If no exception was raised it must have succeeded!
                  logger.warn("Resurrected connection to dead ES instance at #{url}")
                  @state_mutex.synchronize { meta[:dead] = false }
                rescue ::Elasticsearch::Transport::Transport::HostUnreachableError => e
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
              @adapter.perform_request(url, method, path, params, body)
            rescue *@host_unreachable_exceptions => e
              logger.error "[#{e.class}] #{e.message} #{url}" if logger
              raise ::Elasticsearch::Transport::Transport::HostUnreachableError.new(e, url), "Could not reach host #{e.class}: #{e.message}"
            end

            def update_urls(new_urls)
              # Normalize URLs
              new_urls = new_urls.map {|u| u.is_a?(URI) ? u : URI.parse(u) }

              @state_mutex.synchronize do
                # Add new connections
                new_urls.each do |url|
                  # URI objects don't have real hash equality! So, since this isn't perf sensitive we do a linear scan
                  unless @url_info.keys.include?(url)
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

            def size
              @state_mutex.synchronize { @url_info.size }
            end

            def add_url(url)
              @url_info[url] ||= empty_url_meta
            end

            def remove_url(url)
              @url_info.delete(url)
            end

            def empty_url_meta
              {
                :in_use => 0,
                :dead => false
              }
            end

            def with_connection
              url, url_meta = get_connection

              # Custom error class used here so that users may retry attempts if they receive this error
              # should they choose to
              raise NoConnectionAvailableError, "No Available connections" unless url
              yield url
            rescue ::Elasticsearch::Transport::Transport::HostUnreachableError => e
              mark_dead(url, e)
              raise e
            ensure
              return_connection(url)
            end

            def mark_dead(url, error)
              @state_mutex.synchronize do
                url_meta = @url_info[url]
                logger.warn("Marking url #{url} as dead. Last error: [#{error.class}] #{error.message}")
                url_meta[:dead] = true
                url_meta[:last_error] = error
              end
            end

            def url_meta(url)
              @state_mutex.synchronize do
                @url_info[url]
              end
            end

            def get_connection
              @state_mutex.synchronize do
                # The goal here is to pick a random connection from the least-in-use connections
                # We want some randomness so that we don't hit the same node over and over, but
                # we also want more 'fair' behavior in the event of high concurrency
                eligible_set = nil
                lowest_value_seen = nil
                @url_info.each do |url,meta|
                  meta_in_use = meta[:in_use]
                  next if meta[:dead]

                  if lowest_value_seen.nil? || meta_in_use < lowest_value_seen
                    lowest_value_seen = meta_in_use
                    eligible_set = [[url, meta]]
                  elsif lowest_value_seen == meta_in_use
                    eligible_set << [url, meta]
                  end
                end

                return nil if eligible_set.nil?

                pick, pick_meta = eligible_set.sample
                pick_meta[:in_use] += 1

                [pick, pick_meta]
              end
            end

            def return_connection(url)
              @state_mutex.synchronize do
                if @url_info[url] # Guard against the condition where the connection has already been deleted
                  @url_info[url][:in_use] -= 1
                end
              end
            end
          end
        end
      end
    end
  end
end
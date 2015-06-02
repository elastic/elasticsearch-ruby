require 'timeout'
require 'net/http'
require 'fileutils'
require 'socket'
require 'uri'
require 'json'
require 'ansi'

STDOUT.sync = true

class String

  # Redefine the ANSI method: do not print ANSI when not running in the terminal
  #
  def ansi(*args)
    STDOUT.tty? ? ANSI.ansi(self, *args) : self
  end
end

module Elasticsearch
  module Extensions
    module Test

      # A convenience Ruby class for starting and stopping a separate testing in-memory cluster,
      # to not depend on -- and not mess up -- <localhost:9200>.
      #
      # @example Start a cluster with default configuration
      #      require 'elasticsearch/extensions/test/cluster'
      #      Elasticsearch::Extensions::Test::Cluster.start
      #
      # @see Cluster#start Cluster.start
      # @see Cluster#stop Cluster.stop
      #
      module Cluster
        @@number_of_nodes = (ENV['TEST_CLUSTER_NODES'] || 2).to_i
        @@default_cluster_name = "elasticsearch-test-#{Socket.gethostname.downcase}"

        # Starts a cluster
        #
        # Launches the specified number of nodes in test-suitable configuration by default
        # and prints information about the cluster -- unless this specific cluster is running already.
        #
        # Use the {Cluster#stop Cluster.stop} command with the same arguments to stop this cluster.
        #
        # @option arguments [String]  :cluster_name Cluster name (default: `elasticsearch_test`)
        # @option arguments [Integer] :nodes        Number of desired nodes (default: 2)
        # @option arguments [String]  :command      Elasticsearch command (default: `elasticsearch`)
        # @option arguments [String]  :port         Starting port number; will be auto-incremented (default: 9250)
        # @option arguments [String]  :node_name    The node name (will be appended with a number)
        # @option arguments [String]  :path_data    Path to the directory to store data in
        # @option arguments [String]  :path_work    Path to the directory with auxiliary files
        # @option arguments [Boolean] :multicast_enabled Whether multicast is enabled (default: true)
        # @option arguments [Integer] :timeout      Timeout when starting the cluster (default: 30)
        # @option arguments [String]  :network_host The host that nodes will bind on and publish to
        #
        # You can also use environment variables to set these options.
        #
        # @example Start a cluster with default configuration (2 nodes, in-memory, etc)
        #      Elasticsearch::Extensions::Test::Cluster.start
        #
        # @example Start a cluster with a custom configuration
        #      Elasticsearch::Extensions::Test::Cluster.start \
        #        cluster_name: 'my-cluster',
        #        nodes: 3,
        #        node_name: 'my-node',
        #        port: 9350
        #
        # @example Start a cluster with a different Elasticsearch version
        #      Elasticsearch::Extensions::Test::Cluster.start \
        #        command: "/usr/local/Cellar/elasticsearch/1.0.0.Beta2/bin/elasticsearch"
        #
        # @return Boolean
        # @see Cluster#stop Cluster.stop
        #
        def start(arguments={})
          @@number_of_nodes = ( ENV.fetch('TEST_CLUSTER_NODES', arguments[:nodes] || 2) ).to_i

          arguments[:command]           ||= ENV.fetch('TEST_CLUSTER_COMMAND',   'elasticsearch')
          arguments[:port]              ||= (ENV.fetch('TEST_CLUSTER_PORT',     9250).to_i)
          arguments[:cluster_name]      ||= (ENV.fetch('TEST_CLUSTER_NAME',     @@default_cluster_name).chomp)
          arguments[:node_name]         ||= ENV.fetch('TEST_CLUSTER_NODE_NAME', 'node')
          arguments[:path_data]         ||= ENV.fetch('TEST_CLUSTER_DATA',      '/tmp/elasticsearch_test')
          arguments[:path_work]         ||= ENV.fetch('TEST_CLUSTER_TMP',       '/tmp')
          arguments[:es_params]         ||= ENV.fetch('TEST_CLUSTER_PARAMS',    '')
          arguments[:multicast_enabled] ||= ENV.fetch('TEST_CLUSTER_MULTICAST', 'true')
          arguments[:timeout]           ||= (ENV.fetch('TEST_CLUSTER_TIMEOUT', 30).to_i)
          arguments[:network_host]      ||= ENV.fetch('TEST_CLUSTER_NETWORK_HOST', '0.0.0.0')

          # Make sure `cluster_name` is not dangerous
          if arguments[:cluster_name] =~ /^[\/\\]?$/
            raise ArgumentError, "The `cluster_name` parameter cannot be empty string or a slash"
          end

          if running? :on => arguments[:port], :as => arguments[:cluster_name]
            print "[!] Elasticsearch cluster already running".ansi(:red)
            wait_for_green(arguments[:port], arguments[:timeout])
            return false
          end

          # Wipe out data for this cluster name
          FileUtils.rm_rf "#{arguments[:path_data]}/#{arguments[:cluster_name]}"

          print "Starting ".ansi(:faint) +
                @@number_of_nodes.to_s.ansi(:bold, :faint) +
                " Elasticsearch nodes..".ansi(:faint)

          pids = []

          @@number_of_nodes.times do |n|
            n += 1
            command = <<-COMMAND
              #{arguments[:command]} \
                -D es.foreground=yes \
                -D es.cluster.name=#{arguments[:cluster_name]} \
                -D es.node.name=#{arguments[:node_name]}-#{n} \
                -D es.http.port=#{arguments[:port].to_i + (n-1)} \
                -D es.path.data=#{arguments[:path_data]} \
                -D es.path.work=#{arguments[:path_work]} \
                -D es.cluster.routing.allocation.disk.threshold_enabled=false \
                -D es.network.host=#{arguments[:network_host]} \
                -D es.discovery.zen.ping.multicast.enabled=#{arguments[:multicast_enabled]} \
                -D es.script.inline=on \
                -D es.script.indexed=on \
                -D es.node.test=true \
                -D es.node.bench=true \
                -D es.logger.level=DEBUG \
                #{arguments[:es_params]} \
                > /dev/null
            COMMAND
            STDERR.puts command.gsub(/ {1,}/, ' ') if ENV['DEBUG']

            pid = Process.spawn(command)
            Process.detach pid
            pids << pid
          end

          # Check for proceses running
          if `ps -p #{pids.join(' ')}`.split("\n").size < @@number_of_nodes+1
            STDERR.puts "", "[!!!] Process failed to start (see output above)".ansi(:red)
            exit(1)
          end

          wait_for_green(arguments[:port], arguments[:timeout])
          return true
        end

        # Stop the cluster.
        #
        # Fetches the PID numbers from "Nodes Info" API and terminates matching nodes.
        #
        # @example Stop the default cluster
        #      Elasticsearch::Extensions::Test::Cluster.stop
        #
        # @example Stop the cluster reachable on specific port
        #      Elasticsearch::Extensions::Test::Cluster.stop port: 9350
        #
        # @return Boolean
        # @see Cluster#start Cluster.start
        #
        def stop(arguments={})
          arguments[:port] ||= (ENV['TEST_CLUSTER_PORT'] || 9250).to_i

          nodes = begin
            JSON.parse(Net::HTTP.get(URI("http://localhost:#{arguments[:port]}/_nodes/?process")))
          rescue Exception => e
            STDERR.puts "[!] Exception raised when stopping the cluster: #{e.inspect}".ansi(:red)
            nil
          end

          return false if nodes.nil? or nodes.empty?

          pids  = nodes['nodes'].map { |id, info| info['process']['id'] }

          unless pids.empty?
            print "\nStopping Elasticsearch nodes... ".ansi(:faint)
            pids.each_with_index do |pid, i|
              ['INT','KILL'].each do |signal|
                begin
                  Process.kill signal, pid
                rescue Exception => e
                  print "[#{e.class}] PID #{pid} not found. ".ansi(:red)
                end

                # Give the system some breathing space to finish...
                sleep 1

                # Check that pid really is dead
                begin
                  Process.getpgid( pid )
                  # `getpgid` will raise error if pid is dead, so if we get here, try next signal.
                  next
                rescue Errno::ESRCH
                  print "stopped PID #{pid} with #{signal} signal. ".ansi(:green)
                  break # pid is dead
                end
              end
            end
            puts
          else
            false
          end

          return pids
        end

        # Returns true when a specific test node is running within the cluster.
        #
        # @option arguments [Integer] :on The port on which the node is running.
        # @option arguments [String]  :as The cluster name.
        #
        # @return Boolean
        #
        def running?(arguments={})
          port         = arguments[:on] || (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
          cluster_name = arguments[:as] || (ENV.fetch('TEST_CLUSTER_NAME', @@default_cluster_name).chomp)

          if cluster_health = Timeout::timeout(0.25) { __get_cluster_health(port) } rescue nil
            return cluster_health['cluster_name']    == cluster_name && \
                   cluster_health['number_of_nodes'] == @@number_of_nodes
          end
          return false
        end

        # Waits until the cluster is green and prints information
        #
        # @example Print the information about the default cluster
        #     Elasticsearch::Extensions::Test::Cluster.wait_for_green
        #
        # @param (see #__wait_for_status)
        #
        # @return Boolean
        #
        def wait_for_green(port=9250, timeout=60)
          __wait_for_status('green', port, timeout)
        end

        # Blocks the process and waits for the cluster to be in a "green" state.
        #
        # Prints information about the cluster on STDOUT if the cluster is available.
        #
        # @param status  [String]  The status to wait for (yellow, green)
        # @param port    [Integer] The port on which the cluster is reachable
        # @param timeout [Integer] The explicit timeout for the operation
        #
        # @api private
        #
        # @return Boolean
        #
        def __wait_for_status(status='green', port=9250, timeout=30)
          uri = URI("http://localhost:#{port}/_cluster/health?wait_for_status=#{status}")

          Timeout::timeout(timeout) do
            loop do
              response = begin
                JSON.parse(Net::HTTP.get(uri))
              rescue Exception => e
                STDERR.puts e.inspect if ENV['DEBUG']
                nil
              end

              STDERR.puts response.inspect if response && ENV['DEBUG']

              if response && response['status'] == status && ( @@number_of_nodes.nil? || @@number_of_nodes == response['number_of_nodes'].to_i  )
                __print_cluster_info(port) and break
              end

              print '.'.ansi(:faint)
              sleep 1
            end
          end

          return true
        end

        # Print information about the cluster on STDOUT
        #
        # @api private
        #
        def __print_cluster_info(port)
          health = JSON.parse(Net::HTTP.get(URI("http://localhost:#{port}/_cluster/health")))
          nodes  = JSON.parse(Net::HTTP.get(URI("http://localhost:#{port}/_nodes/process,http")))
          master = JSON.parse(Net::HTTP.get(URI("http://localhost:#{port}/_cluster/state")))['master_node']

          puts "\n",
                ('-'*80).ansi(:faint),
               'Cluster: '.ljust(20).ansi(:faint) + health['cluster_name'].to_s.ansi(:faint),
               'Status:  '.ljust(20).ansi(:faint) + health['status'].to_s.ansi(:faint),
               'Nodes:   '.ljust(20).ansi(:faint) + health['number_of_nodes'].to_s.ansi(:faint)

          nodes['nodes'].each do |id, info|
            m = id == master ? '*' : '+'
            puts ''.ljust(20) +
                 "#{m} ".ansi(:faint) +
                 "#{info['name'].ansi(:bold)} ".ansi(:faint) +
                 "| version: #{info['version'] rescue 'N/A'}, ".ansi(:faint) +
                 "pid: #{info['process']['id'] rescue 'N/A'}, ".ansi(:faint) +
                 "address: #{info['http']['bound_address'] rescue 'N/A'}".ansi(:faint)
          end
        end

        # Tries to load cluster health information
        #
        # @api private
        #
        def __get_cluster_health(port=9250)
          uri = URI("http://localhost:#{port}/_cluster/health")
          if response = Net::HTTP.get(uri) rescue nil
            return JSON.parse(response)
          end
        end

        extend self
      end
    end
  end
end

require 'timeout'
require 'net/http'
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

        # Starts a cluster
        #
        # Launches the specified number of nodes in test-suitable configuration by default
        # and prints information about the cluster -- unless this specific cluster is running already.
        #
        # Use the {Cluster#stop Cluster.stop} command with the same arguments to stop this cluster.
        #
        # @option arguments [String]  :command      Elasticsearch command (default: `elasticsearch`).
        # @option arguments [Integer] :nodes        Number of desired nodes (default: 2).
        # @option arguments [String]  :cluster_name Cluster name (default: `elasticsearch_test`).
        # @option arguments [String]  :port         Starting port number; will be auto-incremented (default: 9250).
        # @option arguments [Integer] :timeout      Timeout when starting the cluster (default: 30).
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
          @@number_of_nodes = (ENV['TEST_CLUSTER_NODES'] || arguments[:nodes] || 2).to_i

          arguments[:command]      ||= ENV['TEST_CLUSTER_COMMAND'] || 'elasticsearch'
          arguments[:port]         ||= (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
          arguments[:cluster_name] ||= ENV['TEST_CLUSTER_NAME'] || 'elasticsearch_test'
          arguments[:gateway_type] ||= 'none'
          arguments[:index_store]  ||= 'memory'
          arguments[:path_data]    ||= ENV['TEST_CLUSTER_DATA'] || '/tmp'
          arguments[:es_params]    ||= ENV['TEST_CLUSTER_PARAMS'] || ''
          arguments[:path_work]    ||= '/tmp'
          arguments[:node_name]    ||= 'node'
          arguments[:timeout]      ||= (ENV['TEST_CLUSTER_TIMEOUT'] || 30).to_i

          if running? :on => arguments[:port], :as => arguments[:cluster_name]
            print "[!] Elasticsearch cluster already running".ansi(:red)
            wait_for_green(arguments[:port], arguments[:timeout])
            return false
          end

          print "Starting ".ansi(:faint) +
                @@number_of_nodes.to_s.ansi(:bold, :faint) +
                " Elasticsearch nodes..".ansi(:faint)

          pids = []

          @@number_of_nodes.times do |n|
            n += 1
            pid = Process.spawn <<-COMMAND
              #{arguments[:command]} \
                -D es.foreground=yes \
                -D es.cluster.name=#{arguments[:cluster_name]} \
                -D es.node.name=#{arguments[:node_name]}-#{n} \
                -D es.http.port=#{arguments[:port].to_i + (n-1)} \
                -D es.gateway.type=#{arguments[:gateway_type]} \
                -D es.index.store.type=#{arguments[:index_store]} \
                -D es.path.data=#{arguments[:path_data]} \
                -D es.path.work=#{arguments[:path_work]} \
                -D es.network.host=0.0.0.0 \
                -D es.discovery.zen.ping.multicast.enabled=true \
                -D es.script.disable_dynamic=false \
                -D es.node.test=true \
                -D es.node.bench=true \
                #{arguments[:es_params]} \
                > /dev/null
            COMMAND
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
              begin
                print "stopped PID #{pid}. ".ansi(:green) if Process.kill 'INT', pid
              rescue Exception => e
                print "[#{e.class}] PID #{pid} not found. ".ansi(:red)
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
          cluster_name = arguments[:as] ||  ENV['TEST_CLUSTER_NAME'] || 'elasticsearch_test'

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
                puts e.inspect if ENV['DEBUG']
                nil
              end

              puts response.inspect if ENV['DEBUG']

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
            m = id == master ? '+' : '-'
            puts ''.ljust(20) +
                 "#{m} #{info['name'].ansi(:bold)} | version: #{info['version']}, pid: #{info['process']['id']}, address: #{info['http']['bound_address']}".ansi(:faint)
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

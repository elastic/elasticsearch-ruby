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

      # A convenience Ruby class for starting and stopping an Elasticsearch cluster,
      # eg. for integration tests
      #
      # @example Start a cluster with default configuration,
      #          assuming `elasticsearch` is on $PATH.
      #
      #      require 'elasticsearch/extensions/test/cluster'
      #      Elasticsearch::Extensions::Test::Cluster.start
      #
      # @example Start a cluster with a specific Elasticsearch launch script,
      #          eg. from a downloaded `.tar.gz` distribution
      #
      #      system 'wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.1.1.tar.gz'
      #      system 'tar -xvf elasticsearch-5.1.1.tar.gz'
      #
      #      require 'elasticsearch/extensions/test/cluster'
      #      Elasticsearch::Extensions::Test::Cluster.start command: 'elasticsearch-5.1.1/bin/elasticsearch'
      #
      # @see Cluster#initialize
      #
      module Cluster

        # Starts a cluster
        #
        # @see Cluster#start
        #
        def start(arguments={})
          Cluster.new(arguments).start
        end

        # Stops a cluster
        #
        # @see Cluster#stop
        #
        def stop(arguments={})
          Cluster.new(arguments).stop
        end

        # Returns true when a specific test node is running within the cluster
        #
        # @see Cluster#running?
        #
        def running?(arguments={})
          Cluster.new(arguments).running?
        end

        # Waits until the cluster is green and prints information
        #
        # @see Cluster#wait_for_green
        #
        def wait_for_green(arguments={})
          Cluster.new(arguments).wait_for_green
        end

        module_function :start, :stop, :running?, :wait_for_green

        class Cluster
          attr_reader :arguments

          COMMANDS = {
            '0.90' => lambda { |arguments, node_number|
              <<-COMMAND.gsub(/                /, '')
                #{arguments[:command]} \
                -f \
                -D es.cluster.name=#{arguments[:cluster_name]} \
                -D es.node.name=#{arguments[:node_name]}-#{node_number} \
                -D es.http.port=#{arguments[:port].to_i + (node_number-1)} \
                -D es.path.data=#{arguments[:path_data]} \
                -D es.path.work=#{arguments[:path_work]} \
                -D es.path.logs=#{arguments[:path_logs]} \
                -D es.cluster.routing.allocation.disk.threshold_enabled=false \
                -D es.network.host=#{arguments[:network_host]} \
                -D es.discovery.zen.ping.multicast.enabled=#{arguments[:multicast_enabled]} \
                -D es.script.inline=true \
                -D es.script.indexed=true \
                -D es.node.test=true \
                -D es.node.testattr=test \
                -D es.node.bench=true \
                -D es.path.repo=/tmp \
                -D es.repositories.url.allowed_urls=http://snapshot.test* \
                -D es.logger.level=DEBUG \
                #{arguments[:es_params]} \
                > /dev/null
              COMMAND
              },

            '1.0' => lambda { |arguments, node_number|
              <<-COMMAND.gsub(/                /, '')
                #{arguments[:command]} \
                -D es.foreground=yes \
                -D es.cluster.name=#{arguments[:cluster_name]} \
                -D es.node.name=#{arguments[:node_name]}-#{node_number} \
                -D es.http.port=#{arguments[:port].to_i + (node_number-1)} \
                -D es.path.data=#{arguments[:path_data]} \
                -D es.path.work=#{arguments[:path_work]} \
                -D es.path.logs=#{arguments[:path_logs]} \
                -D es.cluster.routing.allocation.disk.threshold_enabled=false \
                -D es.network.host=#{arguments[:network_host]} \
                -D es.discovery.zen.ping.multicast.enabled=#{arguments[:multicast_enabled]} \
                -D es.script.inline=on \
                -D es.script.indexed=on \
                -D es.node.test=true \
                -D es.node.testattr=test \
                -D es.node.bench=true \
                -D es.path.repo=/tmp \
                -D es.repositories.url.allowed_urls=http://snapshot.test* \
                -D es.logger.level=#{ENV['DEBUG'] ? 'DEBUG' : 'INFO'} \
                #{arguments[:es_params]} \
                > /dev/null
              COMMAND
              },

            '2.0' => lambda { |arguments, node_number|
              <<-COMMAND.gsub(/                /, '')
                #{arguments[:command]} \
                -D es.foreground=yes \
                -D es.cluster.name=#{arguments[:cluster_name]} \
                -D es.node.name=#{arguments[:node_name]}-#{node_number} \
                -D es.http.port=#{arguments[:port].to_i + (node_number-1)} \
                -D es.path.data=#{arguments[:path_data]} \
                -D es.path.work=#{arguments[:path_work]} \
                -D es.path.logs=#{arguments[:path_logs]} \
                -D es.cluster.routing.allocation.disk.threshold_enabled=false \
                -D es.network.host=#{arguments[:network_host]} \
                -D es.script.inline=true \
                -D es.script.stored=true \
                -D es.node.attr.testattr=test \
                -D es.path.repo=/tmp \
                -D es.repositories.url.allowed_urls=http://snapshot.test* \
                -D es.logger.level=DEBUG \
                #{arguments[:es_params]} \
                > /dev/null
              COMMAND
              },

            '5.0' => lambda { |arguments, node_number|
              <<-COMMAND.gsub(/                /, '')
                #{arguments[:command]} \
                -E cluster.name=#{arguments[:cluster_name]} \
                -E node.name=#{arguments[:node_name]}-#{node_number} \
                -E http.port=#{arguments[:port].to_i + (node_number-1)} \
                -E path.data=#{arguments[:path_data]} \
                -E path.logs=#{arguments[:path_logs]} \
                -E cluster.routing.allocation.disk.threshold_enabled=false \
                -E network.host=#{arguments[:network_host]} \
                -E script.inline=true \
                -E script.stored=true \
                -E node.attr.testattr=test \
                -E path.repo=/tmp \
                -E repositories.url.allowed_urls=http://snapshot.test* \
                -E discovery.zen.minimum_master_nodes=#{arguments[:number_of_nodes]-1} \
                -E node.max_local_storage_nodes=#{arguments[:number_of_nodes]} \
                -E logger.level=DEBUG \
                #{arguments[:es_params]} \
                > /dev/null
              COMMAND
            }
          }

          # Create a new instance of the Cluster class
          #
          # @option arguments [String]  :cluster_name Cluster name (default: `elasticsearch_test`)
          # @option arguments [Integer] :number_of_nodes Number of desired nodes (default: 2)
          # @option arguments [String]  :command      Elasticsearch command (default: `elasticsearch`)
          # @option arguments [String]  :port         Starting port number; will be auto-incremented (default: 9250)
          # @option arguments [String]  :node_name    The node name (will be appended with a number)
          # @option arguments [String]  :path_data    Path to the directory to store data in
          # @option arguments [String]  :path_work    Path to the directory with auxiliary files
          # @option arguments [String]  :path_logs    Path to the directory with log files
          # @option arguments [Boolean] :multicast_enabled Whether multicast is enabled (default: true)
          # @option arguments [Integer] :timeout      Timeout when starting the cluster (default: 30)
          # @option arguments [String]  :network_host The host that nodes will bind on and publish to
          # @option arguments [Boolean] :clear_cluster Wipe out cluster content on startup (default: true)
          #
          # You can also use environment variables to set the constructor options (see source).
          #
          # @see Cluster#start
          #
          def initialize(arguments={})
            @arguments = arguments.dup

            @arguments[:command]           ||= ENV.fetch('TEST_CLUSTER_COMMAND',   'elasticsearch')
            @arguments[:port]              ||= ENV.fetch('TEST_CLUSTER_PORT',      9250).to_i
            @arguments[:cluster_name]      ||= ENV.fetch('TEST_CLUSTER_NAME',      __default_cluster_name).chomp
            @arguments[:node_name]         ||= ENV.fetch('TEST_CLUSTER_NODE_NAME', 'node')
            @arguments[:path_data]         ||= ENV.fetch('TEST_CLUSTER_DATA',      '/tmp/elasticsearch_test')
            @arguments[:path_work]         ||= ENV.fetch('TEST_CLUSTER_TMP',       '/tmp')
            @arguments[:path_logs]         ||= ENV.fetch('TEST_CLUSTER_LOGS',      '/tmp/log/elasticsearch')
            @arguments[:es_params]         ||= ENV.fetch('TEST_CLUSTER_PARAMS',    '')
            @arguments[:multicast_enabled] ||= ENV.fetch('TEST_CLUSTER_MULTICAST', 'true')
            @arguments[:timeout]           ||= ENV.fetch('TEST_CLUSTER_TIMEOUT',   30).to_i
            @arguments[:number_of_nodes]   ||= ENV.fetch('TEST_CLUSTER_NODES',     2).to_i
            @arguments[:network_host]      ||= ENV.fetch('TEST_CLUSTER_NETWORK_HOST', __default_network_host)

            @clear_cluster = !!@arguments[:clear_cluster] || (ENV.fetch('TEST_CLUSTER_CLEAR', 'true') != 'false')

            # Make sure `cluster_name` is not dangerous
            raise ArgumentError, "The `cluster_name` argument cannot be empty string or a slash" \
              if @arguments[:cluster_name] =~ /^[\/\\]?$/
          end

          # Starts a cluster
          #
          # Launches the specified number of nodes in a test-suitable configuration and prints
          # information about the cluster -- unless this specific cluster is already running.
          #
          # @example Start a cluster with the default configuration (2 nodes, installed version, etc)
          #      Elasticsearch::Extensions::Test::Cluster::Cluster.new.start
          #
          # @example Start a cluster with a custom configuration
          #      Elasticsearch::Extensions::Test::Cluster::Cluster.new(
          #        cluster_name: 'my-cluster',
          #        number_of_nodes: 3,
          #        node_name: 'my-node',
          #        port: 9350
          #      ).start
          #
          # @example Start a cluster with a different Elasticsearch version
          #      Elasticsearch::Extensions::Test::Cluster::Cluster.new(
          #        command: "/usr/local/Cellar/elasticsearch/1.0.0.Beta2/bin/elasticsearch"
          #      ).start
          #
          # @return Boolean,Array
          # @see Cluster#stop
          #
          def start
            if self.running?
              STDOUT.print "[!] Elasticsearch cluster already running".ansi(:red)
              return false
            end

            __remove_cluster_data if @clear_cluster

            STDOUT.print "Starting ".ansi(:faint) + arguments[:number_of_nodes].to_s.ansi(:bold, :faint) +
                         " Elasticsearch nodes..".ansi(:faint)
            pids = []

            STDERR.puts "Using Elasticsearch version [#{version}]" if ENV['DEBUG']

            arguments[:number_of_nodes].times do |n|
              n += 1
              command =  __command(version, arguments, n)
              STDERR.puts command.gsub(/ {1,}/, ' ') if ENV['DEBUG']

              pid = Process.spawn(command)
              Process.detach pid
              pids << pid
              sleep 1
            end

            __check_for_running_processes(pids)
            wait_for_green
            __print_cluster_info

            return true
          end

          # Stops the cluster
          #
          # Fetches the PID numbers from "Nodes Info" API and terminates matching nodes.
          #
          # @example Stop the default cluster
          #      Elasticsearch::Extensions::Test::Cluster::Cluster.new.stop
          #
          # @example Stop the cluster reachable on specific port
          #      Elasticsearch::Extensions::Test::Cluster::Cluster.new(port: 9350).stop
          #
          # @return Boolean,Array
          # @see Cluster#start
          #
          def stop
            begin
              nodes = __get_nodes
            rescue Exception => e
              STDERR.puts "[!] Exception raised when stopping the cluster: #{e.inspect}".ansi(:red)
              nil
            end

            return false if nodes.nil? or nodes.empty?

            pids  = nodes['nodes'].map { |id, info| info['process']['id'] }

            unless pids.empty?
              STDOUT.print "\nStopping Elasticsearch nodes... ".ansi(:faint)
              pids.each_with_index do |pid, i|
                ['INT','KILL'].each do |signal|
                  begin
                    Process.kill signal, pid
                  rescue Exception => e
                    STDOUT.print "[#{e.class}] PID #{pid} not found. ".ansi(:red)
                  end

                  # Give the system some breathing space to finish...
                  Kernel.sleep 1

                  # Check that pid really is dead
                  begin
                    Process.getpgid pid
                    # `getpgid` will raise error if pid is dead, so if we get here, try next signal
                    next
                  rescue Errno::ESRCH
                    STDOUT.print "Stopped PID #{pid}".ansi(:green) +
                    (ENV['DEBUG'] ? " with #{signal} signal".ansi(:green) : '') +
                    ". ".ansi(:green)
                    break # pid is dead
                  end
                end
              end
              STDOUT.puts
            else
              return false
            end

            return pids
          end

          # Returns true when a specific test node is running within the cluster
          #
          # @return Boolean
          #
          def running?
            if cluster_health = Timeout::timeout(0.25) { __get_cluster_health } rescue nil
              return cluster_health['cluster_name']    == arguments[:cluster_name] && \
                     cluster_health['number_of_nodes'] == arguments[:number_of_nodes]
            end
            return false
          end

          # Waits until the cluster is green and prints information about it
          #
          # @return Boolean
          #
          def wait_for_green
            __wait_for_status('green', 60)
          end

          # Returns the major version of Elasticsearch
          #
          # @return String
          # @see __determine_version
          #
          def version
            @version ||= __determine_version
          end


          # Returns default `:network_host` setting based on the version
          #
          # @api private
          #
          # @return String
          #
          def __default_network_host
            case version
              when /^0|^1/
                '0.0.0.0'
              when /^2/
                '_local_'
              when /^5/
                '_local_'
              else
                raise RuntimeError, "Cannot determine default network host from version [#{version}]"
            end
          end

          # Returns a reasonably unique cluster name
          #
          # @api private
          #
          # @return String
          #
          def __default_cluster_name
            "elasticsearch-test-#{Socket.gethostname.downcase}"
          end

          # Returns the HTTP URL for the cluster based on `:network_host` setting
          #
          # @api private
          #
          # @return String
          #
          def __cluster_url
            if '_local_' == arguments[:network_host]
              "http://localhost:#{arguments[:port]}"
            else
              "http://#{arguments[:network_host]}:#{arguments[:port]}"
            end
          end

          # Determine Elasticsearch version to be launched
          #
          # Tries to parse the version number from the `lib/elasticsearch-X.Y.Z.jar` file,
          # it not available, uses `elasticsearch --version` or `elasticsearch -v`
          #
          # @api private
          #
          # @return String
          #
          def __determine_version
            path_to_lib = File.dirname(arguments[:command]) + '/../lib/'

            jar = Dir.entries(path_to_lib).select { |f| f.start_with? 'elasticsearch' }.first if File.exist? path_to_lib

            version = if jar
              if m = jar.match(/elasticsearch\-(\d+\.\d+.\d+).*/)
                m[1]
              else
                raise RuntimeError, "Cannot determine Elasticsearch version from jar [#{jar}]"
              end
            else
              STDERR.puts "[!] Cannot find Elasticsearch .jar from path to command [#{arguments[:command]}], using `elasticsearch --version`" if ENV['DEBUG']

              output = ''

              begin
                # First, try the new `--version` syntax...
                STDERR.puts "Running [#{arguments[:command]} --version] to determine version" if ENV['DEBUG']
                rout, wout = IO.pipe
                pid = Process.spawn("#{arguments[:command]} --version", out: wout)

                Timeout::timeout(10) do
                  Process.wait(pid)
                  wout.close unless wout.closed?
                  output = rout.read unless rout.closed?
                  rout.close unless rout.closed?
                end
              rescue Timeout::Error
                # ...else, the old `-v` syntax
                STDERR.puts "Running [#{arguments[:command]} -v] to determine version" if ENV['DEBUG']
                output = `#{arguments[:command]} -v`
              ensure
                # Most likely the process has terminated already
                if pid
                  Process.kill('INT', pid) rescue Errno::ESRCH
                end
                wout.close unless wout.closed?
                rout.close unless rout.closed?
              end

              STDERR.puts "> #{output}" if ENV['DEBUG']

              if output.empty?
                raise RuntimeError, "Cannot determine Elasticsearch version from [#{arguments[:command]} --version] or [#{arguments[:command]} -v]"
              end

              if m = output.match(/Version: (\d\.\d.\d).*,/)
                m[1]
              else
                raise RuntimeError, "Cannot determine Elasticsearch version from elasticsearch --version output [#{output}]"
              end
            end

            case version
              when /^0\.90.*/
                '0.90'
              when /^1\..*/
                '1.0'
              when /^2\..*/
                '2.0'
              when /^5\..*/
                '5.0'
              else
                raise RuntimeError, "Cannot determine major version from [#{version}]"
            end
          end

          # Returns the launch command for a specific version
          #
          # @api private
          #
          # @return String
          #
          def __command(version, arguments, node_number)
            if command = COMMANDS[version]
              command.call(arguments, node_number)
            else
              raise ArgumentError, "Cannot find command for version [#{version}]"
            end
          end

          # Blocks the process and waits for the cluster to be in a "green" state
          #
          # Prints information about the cluster on STDOUT if the cluster is available.
          #
          # @param status  [String]  The status to wait for (yellow, green)
          # @param timeout [Integer] The explicit timeout for the operation
          #
          # @api private
          #
          # @return Boolean
          #
          def __wait_for_status(status='green', timeout=30)
            begin
              Timeout::timeout(timeout) do
                loop do
                  response = __get_cluster_health(status)
                  STDERR.puts response if ENV['DEBUG']

                  if response && response['status'] == status && ( arguments[:number_of_nodes].nil? || arguments[:number_of_nodes].to_i == response['number_of_nodes'].to_i  )
                    break
                  end

                  STDOUT.print '.'.ansi(:faint)
                  sleep 1
                end
              end
            rescue Timeout::Error => e
              message = "\nTimeout while waiting for cluster status [#{status}]"
              message += " and [#{arguments[:number_of_nodes]}] nodes" if arguments[:number_of_nodes]
              STDOUT.puts message.ansi(:red, :bold)
              raise e
            end

            return true
          end

          # Print information about the cluster on STDOUT
          #
          # @api private
          #
          # @return Nil
          #
          def __print_cluster_info
            health = JSON.parse(Net::HTTP.get(URI("#{__cluster_url}/_cluster/health")))
            nodes  = if version == '0.90'
              JSON.parse(Net::HTTP.get(URI("#{__cluster_url}/_nodes/?process&http")))
            else
              JSON.parse(Net::HTTP.get(URI("#{__cluster_url}/_nodes/process,http")))
            end
            master = JSON.parse(Net::HTTP.get(URI("#{__cluster_url}/_cluster/state")))['master_node']

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
          # @return Hash,Nil
          #
          def __get_cluster_health(status=nil)
            uri = URI("#{__cluster_url}/_cluster/health")
            uri.query = "wait_for_status=#{status}" if status

            begin
              response = Net::HTTP.get(uri)
            rescue Exception => e
              STDERR.puts e.inspect if ENV['DEBUG']
              return nil
            end

            JSON.parse(response)
          end

          # Remove the data directory
          #
          # @api private
          #
          def __remove_cluster_data
            FileUtils.rm_rf arguments[:path_data]
          end


          # Check whether process for PIDs are running
          #
          # @api private
          #
          def __check_for_running_processes(pids)
            if `ps -p #{pids.join(' ')}`.split("\n").size < arguments[:number_of_nodes]+1
              STDERR.puts "", "[!!!] Process failed to start (see output above)".ansi(:red)
              exit(1)
            end
          end

          # Get the information about nodes
          #
          # @api private
          #
          def __get_nodes
            JSON.parse(Net::HTTP.get(URI("#{__cluster_url}/_nodes/process")))
          end
        end
      end
    end
  end
end

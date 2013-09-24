require 'ansi/code'

module Elasticsearch

  # A convenience Ruby class for starting and stopping a separate testing cluster,
  # to not depend on -- and not mess up -- <localhost:9200>.
  #
  module TestCluster
    require 'timeout'
    require 'net/http'
    require 'uri'

    @@number_of_nodes = 2
    @@pids            = []

    # Start a cluster
    #
    # Starts the desired number of nodes in test-suitable configuration (memory store, no persistence, etc).
    #
    # @option arguments [String]  :command      Elasticsearch command (default: `elasticsearch`).
    # @option arguments [Integer] :count        Number of desired nodes (default: 2).
    # @option arguments [String]  :cluster_name Cluster name (default: `elasticsearch-ruby-test`).
    # @option arguments [String]  :port         Starting port number; will be auto-incremented (default: 9250).
    #
    # You can also use environment variables to set these options.
    #
    def start(arguments={})
      arguments[:command] = ENV['TEST_CLUSTER_COMMAND'] || 'elasticsearch'

      @@number_of_nodes = arguments[:count] if arguments[:count]

      arguments[:port]         = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
      arguments[:cluster_name] = ENV['TEST_CLUSTER_NAME'] || 'elasticsearch-ruby-test'
      arguments[:node_name]    = 'node'

      if running? :on => arguments[:port], :as => arguments[:cluster_name]
        print ANSI.red("Elasticsearch cluster already running")
        __wait_for_green(arguments[:port])
        exit(0)
      end

      print ANSI.faint("Starting ") + ANSI.ansi(@@number_of_nodes.to_s, :bold, :faint) + ANSI.faint(" Elasticsearch nodes")

      @@number_of_nodes.times do |n|
        n += 1
        pidfile = File.expand_path("tmp/elasticsearch-#{n}.pid", Dir.pwd)
        pid = Process.spawn <<-COMMAND
          #{arguments[:command]} \
            -D es.foreground=yes \
            -D es.cluster.name=#{arguments[:cluster_name]} \
            -D es.node.name=#{arguments[:node_name]}-#{n} \
            -D es.http.port=#{arguments[:port].to_i + (n-1)} \
            -D es.gateway.type=none \
            -D es.index.store.type=memory \
            -D es.network.host=0.0.0.0 \
            -D es.discovery.zen.ping.multicast.enabled=true \
            -D es.pidfile=#{pidfile} \
            > /dev/null 2>&1
        COMMAND
        Process.detach pid
      end

      __wait_for_green(arguments[:port])
    end

    # Stop the cluster.
    #
    # Gets the PID numbers from pidfiles in `$CWD/tmp` and stops any matching nodes.
    #
    def stop
      pids     = __get_pids
      pidfiles = __get_pidfiles

      unless pids.empty?
        print "Stopping Elasticsearch nodes... "
        pids.each_with_index do |pid, i|
          begin
            print ANSI.green("stopped PID #{pid}. ") if Process.kill 'KILL', pid
          rescue Exception => e
            print ANSI.red("[#{e.class}] PID #{pid} not found. ")
          end
          File.delete pidfiles[i] if pidfiles[i] && File.exists?(pidfiles[i])
        end
        puts
      end
    end

    # Returns true when a specific test node is running.
    #
    # @option arguments [Integer] :on The port on which the node is running.
    # @option arguments [String]  :as The cluster name.
    #
    def running?(arguments={})
      port         = arguments[:on] || 9250
      cluster_name = arguments[:as] || 'elasticsearch-ruby-test'

      if cluster_health = Timeout::timeout(0.25) { __get_cluster_health(port) } rescue nil
        return cluster_health['cluster_name']    == cluster_name && \
               cluster_health['number_of_nodes'] == @@number_of_nodes
      end
      return false
    end

    # Blocks the process and waits for the cluster to be in a "green" state.
    # Prints information about the cluster on STDOUT.
    #
    def __wait_for_green(port=9250)
      uri = URI("http://localhost:#{port}/_cluster/health")

      Timeout::timeout(30) do
        loop do
          response = Net::HTTP.get(uri) rescue nil
          if response
            pids = __get_pids

            json = MultiJson.load(response)
            if json['status'] == 'green' && json['number_of_nodes'].to_i == @@number_of_nodes
              puts '',
                   ANSI.faint('-'*80),
                   ANSI.faint(
                    'Cluster: '.ljust(20)         + json['cluster_name'].to_s    + "\n" +
                    'Status: '.ljust(20)          + json['status'].to_s          + "\n" +
                    'Number of nodes: '.ljust(20) + json['number_of_nodes'].to_s + "\n" +
                    'PIDs'.ljust(20)              + pids.inspect
                  ),
                  ANSI.faint('-'*80)
              break
            end
          end
          print ANSI.faint('.')
          sleep 1
        end
      end
    end

    # Tries to load cluster health information
    #
    def __get_cluster_health(port=9250)
      uri = URI("http://localhost:#{port}/_cluster/health")
      if response = Net::HTTP.get(uri) rescue nil
        return MultiJson.load(response)
      end
    end

    # Returns a collection of PID numbers from pidfiles.
    def __get_pids
      __get_pidfiles.map { |pidfile| File.read(pidfile).to_i }.uniq
    end

    # Returns a collection of files with PID information.
    #
    def __get_pidfiles
      Dir[File.expand_path('tmp/elasticsearch-*.pid', Dir.pwd)]
    end

    extend self
  end
end

require 'ansi/code'

module IntegrationTestStartupShutdown
  @@started           = false
  @@shutdown_blocks ||= []

  def startup &block
    return if started?
    @@started = true
    yield block if block_given?
  end

  def shutdown &block
    @@shutdown_blocks << block if block_given?
  end

  def started?
    !! @@started
  end

  def __run_at_exit_hooks
    return unless started?
    STDERR.puts ANSI.faint("Running at_exit hooks...")
    puts ANSI.faint('-'*80)
    @@shutdown_blocks.each { |b| b.call }
    puts ANSI.faint('-'*80)
  end
end

module Elasticsearch
  module TestServer
    require 'timeout'
    require 'net/http'
    require 'uri'

    @@number_of_nodes = 2
    @@pids            = []

    def start(arguments={})
      unless system "which elasticsearch > /dev/null 2>&1"
        STDERR.puts ANSI.red("[ERROR] Elasticsearch can't be started, is it installed? Run: $ which elasticsearch"), ''
        abort
      end

      @@number_of_nodes = arguments[:count] if arguments[:count]

      arguments[:port]         ||= 9250
      arguments[:cluster_name] ||= 'elasticsearch-ruby-test'
      arguments[:node_name]    ||= 'test'

      if running? on: arguments[:port], as: arguments[:cluster_name]
        print ANSI.red("Elasticsearch cluster already running")
        __wait_for_green(arguments[:port])
        exit(0)
      end

      print ANSI.faint("Starting ") + ANSI.ansi(@@number_of_nodes.to_s, :bold, :faint) + ANSI.faint(" Elasticsearch nodes")

      @@number_of_nodes.times do |n|
        n += 1
        pidfile = File.expand_path("../../tmp/elasticsearch-#{n}.pid", __FILE__)
        pid = Process.spawn <<-COMMAND
          elasticsearch \
            -D es.foreground=no \
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

    def running?(arguments={})
      port         = arguments[:on] || 9250
      cluster_name = arguments[:as] || 'elasticsearch-ruby-test'

      if cluster_health = Timeout::timeout(0.25) { __get_cluster_health(port) } rescue nil
        return cluster_health['cluster_name']    == cluster_name && \
               cluster_health['number_of_nodes'] == @@number_of_nodes
      end
      return false
    end

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

    def __get_cluster_health(port=9250)
      uri = URI("http://localhost:#{port}/_cluster/health")
      if response = Net::HTTP.get(uri) rescue nil
        return MultiJson.load(response)
      end
    end

    def __get_pids
      __get_pidfiles.map { |pidfile| File.read(pidfile).to_i }.uniq
    end

    def __get_pidfiles
      Dir[File.expand_path('../../tmp/elasticsearch-*.pid', __FILE__)]
    end

    extend self
  end
end

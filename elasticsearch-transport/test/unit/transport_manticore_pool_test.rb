require 'test_helper'

unless JRUBY
  version = ( defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'Ruby' ) + ' ' + RUBY_VERSION
  puts "SKIP: '#{File.basename(__FILE__)}' only supported on JRuby (you're running #{version})"
else
  require 'elasticsearch/transport/transport/http/manticore/pool'
  require 'manticore'

  class Elasticsearch::Transport::Transport::HTTP::ManticorePoolTest < Test::Unit::TestCase
    include Elasticsearch::Transport::Transport::HTTP

      def setup
        @logger = Logger.new(StringIO.new)
        @adapter = mock()
        @healthcheck_path = "/healthcheck"
        @urls = ["http://localhost:9200", "http://localhost:9201", "http://localhost:9202"]
        @url_uris = @urls.map {|u| URI.parse(u) }
        @resurrect_interval = 3
        @pool = ::Elasticsearch::Transport::Transport::HTTP::Manticore::Pool.new(@logger, @adapter, @healthcheck_path, @urls, @resurrect_interval)
      rescue Exception => e
        require 'pry'; binding.pry if !@pool
      end

      def teardown
        @adapter.expects(:close)
        @pool.close
      end

      def test_clean_close
        @adapter.expects(:close)
        @pool.close
      end

    def test_connection_correctly_get_url_from_list_of_open_urls
      @pool.with_connection do |c|
        assert(@url_uris.include?(c))
      end
    end

    def test_connection_minimize_number_of_connections_to_url
      connected_urls = []
      (@urls.size*2).times do
        c,meta = @pool.get_connection
        connected_urls << c
      end
      connected_urls.each {|u| @pool.return_connection(u) }
      @urls.each do |url|
        assert_equal(2, connected_urls.select {|u| u == URI.parse(url)}.size)
      end
    end

    def test_resurrection_of_dead
      u,m = @pool.get_connection

      # The resurrectionist will call this to check on the backend
      @adapter.expects(:perform_request).with(u, 'GET', @healthcheck_path, {}, nil).returns(::Elasticsearch::Transport::Transport::Response.new(200, "", {}))

      @pool.return_connection(u)
      @pool.mark_dead(u, Exception.new)
      assert(@pool.url_meta(u)[:dead])
      sleep @resurrect_interval + 1
      assert(!@pool.url_meta(u)[:dead])
    end

  end
end

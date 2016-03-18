require 'test_helper'

unless JRUBY
  version = ( defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'Ruby' ) + ' ' + RUBY_VERSION
  puts "SKIP: '#{File.basename(__FILE__)}' only supported on JRuby (you're running #{version})"
else
  require 'elasticsearch/transport/transport/http/manticore/pool'
  require 'manticore'

  class Elasticsearch::Transport::Transport::HTTP::ManticorePoolTest < Test::Unit::TestCase
    include Elasticsearch::Transport::Transport::HTTP

    context "Manticore transport" do
      setup do
        @logger = Logger.new(StringIO.new)
        @adapter = mock()
        @healthcheck_path = "/healthcheck"
        @urls = ["http://localhost:9200", "http://localhost:9201", "http://localhost:9202"]
        @url_uris = @urls.map {|u| URI.parse(u) }
        @resurrect_interval = 3
        @pool = ::Elasticsearch::Transport::Transport::HTTP::Manticore::Pool.new(@logger, @adapter, @healthcheck_path, @urls, @resurrect_interval)
      end

      teardown do
        @adapter.expects(:close)
        @pool.close
      end

      should "close cleanly" do
        @adapter.expects(:close)
        @pool.close
      end

      context "#with_connection" do
        should "correctly get an URL from the list of open URLs" do
          @pool.with_connection do |c|
            assert(@url_uris.include?(c))
          end
        end

        should "minimize the number of connections to a given URL" do
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

        should "resurrect dead connections" do
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
  end
end

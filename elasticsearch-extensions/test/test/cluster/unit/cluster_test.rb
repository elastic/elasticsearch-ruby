require 'test_helper'

require 'elasticsearch/extensions/test/cluster'

class Elasticsearch::Extensions::TestClusterTest < Elasticsearch::Test::UnitTestCase
  include Elasticsearch::Extensions::Test
  context "The Test::Cluster" do
    context "module" do
      should "delegate the methods to the class" do
        Cluster::Cluster
          .expects(:new)
          .with({foo: 'bar'})
          .returns(mock start: true, stop: true, running?: true, wait_for_green: true)
          .times(4)

        Elasticsearch::Extensions::Test::Cluster.start foo: 'bar'
        Elasticsearch::Extensions::Test::Cluster.stop foo: 'bar'
        Elasticsearch::Extensions::Test::Cluster.running? foo: 'bar'
        Elasticsearch::Extensions::Test::Cluster.wait_for_green foo: 'bar'
      end
    end

    context "class" do
      setup do
        Elasticsearch::Extensions::Test::Cluster::Cluster.any_instance.stubs(:__default_network_host).returns('_local_')

        @subject = Elasticsearch::Extensions::Test::Cluster::Cluster.new(number_of_nodes: 1)
        @subject.stubs(:__remove_cluster_data).returns(true)
      end

      teardown do
        ENV.delete('TEST_CLUSTER_PORT')
      end

      should "be initialized with parameters" do
        c = Cluster::Cluster.new port: 9400

        assert_equal 9400, c.arguments[:port]
      end

      should "not modify the arguments" do
        args = { port: 9400 }.freeze

        assert_nothing_raised { Cluster::Cluster.new args }
        assert_nil args[:command]
      end

      should "take parameters from environment variables" do
        ENV['TEST_CLUSTER_PORT'] = '9400'

        c = Cluster::Cluster.new

        assert_equal 9400, c.arguments[:port]
      end

      should "raise exception for dangerous cluster name" do
        assert_raise(ArgumentError) { Cluster::Cluster.new cluster_name: '' }
        assert_raise(ArgumentError) { Cluster::Cluster.new cluster_name: '/' }
      end

      should "have a version" do
        @subject.unstub(:version)
        @subject.expects(:__determine_version).returns('2.0')
        assert_equal '2.0', @subject.version
      end

      should "have a default network host" do
        Cluster::Cluster.any_instance.unstub(:__default_network_host)
        Cluster::Cluster.any_instance.stubs(:version).returns('5.0')

        assert_equal '_local_', Cluster::Cluster.new.__default_network_host
      end

      should "have a default cluster name" do
        Socket.stubs(:gethostname).returns('FOOBAR')

        assert_equal 'elasticsearch-test-foobar', Cluster::Cluster.new.__default_cluster_name
      end

      should "have a cluster URL for new versions" do
        assert_equal  'http://localhost:9250', Cluster::Cluster.new(network_host: '_local_').__cluster_url
      end

      should "have a cluster URL for old versions" do
        assert_equal  'http://192.168.1.1:9250', Cluster::Cluster.new(network_host: '192.168.1.1').__cluster_url
      end

      should "return corresponding command to a version" do
        assert_match /\-D es\.foreground=yes/, @subject.__command('2.0', @subject.arguments, 1)
      end

      should "raise an error when a corresponding command cannot be found" do
        assert_raise ArgumentError do
          @subject.__command('FOOBAR', @subject.arguments, 1)
        end
      end

      should "remove cluster data" do
        @subject.unstub(:__remove_cluster_data)
        FileUtils.expects(:rm_rf).with("/tmp/elasticsearch_test")

        @subject.__remove_cluster_data
      end

      should "not log when :quiet" do
        c = Cluster::Cluster.new quiet: true

        STDERR.expects(:puts).never
        c.__log 'QUIET'
      end

      context "when starting a cluster, " do
        should "return false when it's already running" do
          Process.expects(:spawn).never

          c = Cluster::Cluster.new

          c.expects(:running?).returns(true)

          assert_equal false, c.start
        end

        should "start the specified number of nodes" do
          Process.expects(:spawn).times(3)
          Process.expects(:detach).times(3)

          c = Cluster::Cluster.new number_of_nodes: 3

          c.expects(:running?).returns(false)

          c.unstub(:__remove_cluster_data)
          c.expects(:__remove_cluster_data).returns(true)

          c.expects(:wait_for_green).returns(true)
          c.expects(:__check_for_running_processes).returns(true)
          c.expects(:__determine_version).returns('5.0')
          c.expects(:__cluster_info).returns('CLUSTER INFO')

          assert_equal true, c.start
        end
      end

      context "when stopping a cluster" do
        setup do
          @subject = Elasticsearch::Extensions::Test::Cluster::Cluster.new
        end

        should "print information about an exception" do
          @subject.expects(:__get_nodes).raises(Errno::ECONNREFUSED)

          assert_nothing_raised do
            assert_equal false, @subject.stop
          end
        end

        should "return false when the nodes are empty" do
          @subject.expects(:__get_nodes).returns({})
          assert_equal false, @subject.stop
        end

        should "kill each node" do
          @subject.expects(:__get_nodes).returns({'nodes' => { 'n1' => { 'process' => { 'id' => 1 }},
                                                               'n2' => { 'process' => { 'id' => 2 }} }})

          Kernel.stubs(:sleep)
          Process.expects(:kill).with('INT', 1)
          Process.expects(:kill).with('INT', 2)
          Process.expects(:getpgid).with(1).raises(Errno::ESRCH)
          Process.expects(:getpgid).with(2).raises(Errno::ESRCH)

          assert_equal [1, 2], @subject.stop
        end
      end

      context "when checking if the cluster is running" do
        setup do
          @subject = Elasticsearch::Extensions::Test::Cluster::Cluster.new \
                       cluster_name: 'test',
                       number_of_nodes: 2
        end

        should "return true" do
          @subject.expects(:__get_cluster_health).returns({'cluster_name' => 'test', 'number_of_nodes' => 2})
          assert_equal true, @subject.running?
        end

        should "return false" do
          @subject.expects(:__get_cluster_health).returns({'cluster_name' => 'test', 'number_of_nodes' => 1})
          assert_equal false, @subject.running?
        end
      end

      context "when waiting for the green state" do
        should "return true" do
          @subject.expects(:__wait_for_status).returns(true)
          assert_equal true, @subject.wait_for_green
        end
      end

      context "when waiting for cluster state" do
        setup do
          @subject = Elasticsearch::Extensions::Test::Cluster::Cluster.new \
                       cluster_name: 'test',
                       number_of_nodes: 1
        end

        should "return true" do
          @subject
            .expects(:__get_cluster_health)
            .with('yellow')
            .returns({'status' => 'yellow', 'cluster_name' => 'test', 'number_of_nodes' => 1})

          @subject.__wait_for_status('yellow')
        end
      end

      context "when getting the cluster health" do
        should "return the response" do
          Net::HTTP
            .expects(:get)
            .with(URI('http://localhost:9250/_cluster/health'))
            .returns(JSON.dump({'status' => 'yellow', 'cluster_name' => 'test', 'number_of_nodes' => 1}))

          @subject.__get_cluster_health
        end

        should "wait for status" do
          Net::HTTP
            .expects(:get)
            .with(URI('http://localhost:9250/_cluster/health?wait_for_status=green'))
            .returns(JSON.dump({'status' => 'yellow', 'cluster_name' => 'test', 'number_of_nodes' => 1}))

          @subject.__get_cluster_health('green')
        end
      end

      context "when getting the list of nodes" do
        should "return the response" do
          Net::HTTP
            .expects(:get)
            .with(URI('http://localhost:9250/_nodes/process'))
            .returns(JSON.dump({'nodes' => { 'n1' => {}, 'n2' => {} } }))

          assert_equal 'n1', @subject.__get_nodes['nodes'].keys.first
        end
      end

      context "when determining a version" do
        setup do
          @subject = Elasticsearch::Extensions::Test::Cluster::Cluster.new command: '/foo/bar/bin/elasticsearch'
        end

        should "return version from lib/elasticsearch.X.Y.Z.jar" do
          File.expects(:exist?).with('/foo/bar/bin/../lib/').returns(true)
          Dir.expects(:entries).with('/foo/bar/bin/../lib/').returns(['foo.jar', 'elasticsearch-foo-1.0.0.jar', 'elasticsearch-2.3.0.jar', 'elasticsearch-bar-9.9.9.jar'])

          assert_equal '2.0', @subject.__determine_version
        end

        should "return version from `elasticsearch --version`" do
          File.expects(:exist?).with('/foo/bar/bin/../lib/').returns(false)
          File.expects(:exist?).with('/foo/bar/bin/elasticsearch').returns(true)

          io = mock('IO')
          io.expects(:pid).returns(123)
          io.expects(:read).returns('Version: 2.3.0-SNAPSHOT, Build: d1c86b0/2016-03-30T10:43:20Z, JVM: 1.8.0_60')
          io.expects(:closed?).returns(false)
          io.expects(:close)
          IO.expects(:popen).returns(io)

          Process.stubs(:wait)
          Process.expects(:kill).with('INT', 123)

          assert_equal '2.0', @subject.__determine_version
        end

        should "return version from arguments" do
          cluster = Elasticsearch::Extensions::Test::Cluster::Cluster.new command: '/foo/bar/bin/elasticsearch', version: '5.2'
          assert_equal '5.0', cluster.__determine_version
        end

        should "raise an exception when the version cannot be parsed from .jar" do
          # Incorrect jar version (no dots)
          File.expects(:exist?).with('/foo/bar/bin/../lib/').returns(true)
          Dir.expects(:entries).with('/foo/bar/bin/../lib/').returns(['elasticsearch-100.jar'])

          assert_raise(RuntimeError) { @subject.__determine_version }
        end

        should "raise an exception when the version cannot be parsed from command output" do
          File.expects(:exist?).with('/foo/bar/bin/../lib/').returns(false)
          File.expects(:exist?).with('/foo/bar/bin/elasticsearch').returns(true)

          io = mock('IO')
          io.expects(:pid).returns(123)
          io.expects(:read).returns('Version: FOOBAR')
          io.expects(:closed?).returns(false)
          io.expects(:close)
          IO.expects(:popen).returns(io)

          Process.stubs(:wait)
          Process.expects(:kill).with('INT', 123)

          assert_raise(RuntimeError) { @subject.__determine_version }
        end

        should "raise an exception when the version cannot be converted to short version" do
          # There's no Elasticsearch version 3...
          File.expects(:exist?).with('/foo/bar/bin/../lib/').returns(true)
          Dir.expects(:entries).with('/foo/bar/bin/../lib/').returns(['elasticsearch-3.2.1.jar'])

          assert_raise(RuntimeError) { @subject.__determine_version }
        end

        should "raise an exception when the command cannot be found" do
          @subject = Elasticsearch::Extensions::Test::Cluster::Cluster.new

          File.expects(:exist?).with('./../lib/').returns(false)
          File.expects(:exist?).with('elasticsearch').returns(false)
          @subject.expects(:`).returns('')

          assert_raise(Errno::ENOENT) { @subject.__determine_version }
        end
      end
    end

  end
end

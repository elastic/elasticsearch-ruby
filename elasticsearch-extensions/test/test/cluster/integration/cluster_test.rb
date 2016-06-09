require 'test_helper'
require 'pathname'

require 'elasticsearch/extensions/test/cluster'

class Elasticsearch::Extensions::TestClusterIntegrationTest < Test::Unit::TestCase
  context "The Test::Cluster" do
    PATH_TO_BUILDS = Pathname(File.expand_path('../../../../../../tmp/builds', __FILE__))

    unless PATH_TO_BUILDS.exist?
      puts "Path to builds doesn't exist, skipping TestClusterIntegrationTest"
      exit(0)
    end

    @builds = begin
      PATH_TO_BUILDS.entries.reject { |f| f.to_s =~ /^\./ }
    rescue Errno::ENOENT
      []
    end

    @builds.each do |build|
      should "start and stop #{build.to_s}" do
        puts ("----- #{build.to_s} " + "-"*(80-7-build.to_s.size)).to_s.ansi(:bold)
        Elasticsearch::Extensions::Test::Cluster.start command: PATH_TO_BUILDS.join(build.join('bin/elasticsearch')).to_s
        Elasticsearch::Extensions::Test::Cluster.stop command: PATH_TO_BUILDS.join(build.join('bin/elasticsearch')).to_s
      end
    end
  end
end

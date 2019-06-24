require 'elasticsearch'
require 'elasticsearch-transport'
require 'logger'
require 'ansi/code'
require 'hashie/mash'
require 'pry-nav'
if defined?(JRUBY_VERSION)
  require 'elasticsearch/transport/transport/http/manticore'
else
  require 'elasticsearch/transport/transport/http/curb'
  require 'curb'
end

# The hosts to use for creating a elasticsearch client.
#
# @since 7.0.0
ELASTICSEARCH_HOSTS = if hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS']
                        hosts.split(',').map do |host|
                          /(http\:\/\/)?(\S+)/.match(host)[2]
                        end
                      end.freeze

TEST_HOST, TEST_PORT = ELASTICSEARCH_HOSTS.first.split(':') if ELASTICSEARCH_HOSTS

# Are we testing on JRuby?
#
# @return [ true, false ] Whether JRuby is being used.
#
# @since 7.0.0
def jruby?
  RUBY_PLATFORM =~ /\bjava\b/
end

# The names of the connected nodes.
#
# @return [ Array<String> ] The node names.
#
# @since 7.0.0
def node_names
  $node_names ||= default_client.nodes.stats['nodes'].collect do |name, stats|
    stats['name']
  end
end

# The default client.
#
# @return [ Elasticsearch::Client ] The default client.
#
# @since 7.0.0
def default_client
  $client ||= Elasticsearch::Client.new(hosts: ELASTICSEARCH_HOSTS)
end

module Config

  def self.included(context)

    # Get the hosts to use to connect an elasticsearch client.
    #
    # @since 7.0.0
    context.let(:hosts) { ELASTICSEARCH_HOSTS }
  end
end

RSpec.configure do |config|
  config.include(Config)
  config.formatter = 'documentation'
  config.color = true
end

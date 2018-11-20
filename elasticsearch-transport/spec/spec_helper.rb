require 'elasticsearch'
require 'elasticsearch-transport'
require 'logger'
require 'ansi/code'

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.color = true
end

TEST_PORTS = [9250, 9200]
TEST_HOSTS = TEST_PORTS.map { |port| "localhost:#{port}" }

def jruby?
  RUBY_PLATFORM =~ /\bjava\b/
end

require 'patron' unless jruby?
if defined?(JRUBY_VERSION)
  require 'pry-nav'
else
  require 'pry-byebug'
end
require 'yaml'
require 'elasticsearch'
require 'elasticsearch/xpack'
require 'logger'
require 'openssl'

module HelperModule
  def self.included(context)

    context.let(:client_double) do
      Class.new { include Elasticsearch::XPack::API }.new.tap do |client|
        expect(client).to receive(:perform_request).with(*expected_args).and_return(response_double)
      end
    end

    context.let(:client) do
      Class.new { include Elasticsearch::XPack::API }.new.tap do |client|
        expect(client).to receive(:perform_request).with(*expected_args).and_return(response_double)
      end
    end

    context.let(:response_double) do
      double('response', status: 200, body: {}, headers: {})
    end
  end
end

RSpec.configure do |config|
  config.include(HelperModule)
  config.formatter = 'documentation'
  config.color = true
end

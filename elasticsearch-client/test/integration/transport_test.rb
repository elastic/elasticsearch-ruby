require 'test_helper'

class Elasticsearch::Client::ClientIntegrationTest < Elasticsearch::IntegrationTest
  startup do
    Elasticsearch::TestCluster.start if ENV['SERVER'] and not Elasticsearch::TestCluster.running?
  end

  context "Transport" do
    should "allow to customize the Faraday adapter" do
      require 'typhoeus'
      require 'typhoeus/adapters/faraday'

      transport = Elasticsearch::Client::Transport::HTTP::Faraday.new \
        :hosts => [ { :host => 'localhost', :port => '9250' } ] do |f|
          f.response :logger
          f.adapter  :typhoeus
        end

      client = Elasticsearch::Client::Client.new nil, transport: transport
      client.perform_request 'GET', ''
    end

    should "use the Curb client" do
      require 'curb'
      require 'elasticsearch/core/transport/http/curb'

      transport = Elasticsearch::Client::Transport::HTTP::Curb.new \
        :hosts => [ { :host => 'localhost', :port => '9250' } ] do |curl|
          curl.verbose = true
        end

      client = Elasticsearch::Client::Client.new nil, transport: transport
      client.perform_request 'GET', ''
    end
  end

end

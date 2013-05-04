require 'test_helper'

class Elasticsearch::Client::Transport::SerializerTest < Test::Unit::TestCase

  context "Serializer" do

    should "use MultiJson by default" do
      ::MultiJson.expects(:load)
      ::MultiJson.expects(:dump)
      Elasticsearch::Client::Transport::Serializer::MultiJson.new.load('{}')
      Elasticsearch::Client::Transport::Serializer::MultiJson.new.dump({})
    end

  end

end

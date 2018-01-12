require 'test_helper'

class Elasticsearch::Transport::Transport::SerializerTest < Minitest::Test

  context "Serializer" do

    should "use MultiJson by default" do
      ::MultiJson.expects(:load)
      ::MultiJson.expects(:dump)
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.load('{}')
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.dump({})
    end

  end

end

require 'test_helper'

class Elasticsearch::Transport::Transport::SerializerTest < Test::Unit::TestCase

  context "Serializer" do

    should "use MultiJson's dump/load methods when multi_json >= 1.3.0 is installed" do
      Gem.stubs(:loaded_specs).returns({'multi_json' => Gem::Specification.new('multi_json', '1.13.2')})
      ::MultiJson.expects(:load)
      ::MultiJson.expects(:dump)
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.load('{}')
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.dump({})
    end

    should "use MultiJson's encode/decode when multi_json < 1.3.0 is installed" do
      Gem.stubs(:loaded_specs).returns({'multi_json' => Gem::Specification.new('multi_json', '1.2.0')})
      ::MultiJson.expects(:decode)
      ::MultiJson.expects(:encode)
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.load('{}')
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.dump({})
    end

  end

end

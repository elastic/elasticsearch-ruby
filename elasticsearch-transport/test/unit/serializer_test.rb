# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'

class Elasticsearch::Transport::Transport::SerializerTest < Test::Unit::TestCase

  context "Serializer" do

    should "use MultiJson by default" do
      ::MultiJson.expects(:load)
      ::MultiJson.expects(:dump)
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.load('{}')
      Elasticsearch::Transport::Transport::Serializer::MultiJson.new.dump({})
    end

  end

end

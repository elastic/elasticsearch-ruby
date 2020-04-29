# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'test_helper'

class Elasticsearch::Transport::Transport::ResponseTest < Minitest::Test
  context "Response" do

    should "force-encode the body into UTF" do
      body = "Hello Encoding!".encode(Encoding::ISO_8859_1)
      assert_equal 'ISO-8859-1', body.encoding.name

      response = Elasticsearch::Transport::Transport::Response.new 200, body
      assert_equal 'UTF-8', response.body.encoding.name
    end unless RUBY_1_8

  end
end

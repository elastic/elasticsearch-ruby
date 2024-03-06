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

class RSpecCustomFormatter < RSpec::Core::Formatters::JsonFormatter
  RSpec::Core::Formatters.register self

  LOGFILE = File.new("tmp/rspec-#{ENV['TEST_SUITE']}-#{RUBY_VERSION}.log", 'w')

  def close(_notification)
    @output_hash[:examples].map do |example|
      regexp = /\S+\/\S+/
      filename = example[:full_description].match(/\S+\/\S+/)[0]
      log ="#{filename} | #{example[:status]} | #{example[:run_time]} | #{example[:full_description]}\n"
      File.write(LOGFILE, log, mode: 'a')
    end
  end
end

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

# encoding: utf-8

require 'elasticsearch/extensions'

require 'ansi'
require 'ansi/table'
require 'ansi/terminal'

require 'delegate'
require 'elasticsearch/transport/transport/response'

require 'elasticsearch/extensions/ansi/helpers'
require 'elasticsearch/extensions/ansi/actions'
require 'elasticsearch/extensions/ansi/response'

module Elasticsearch
  module Extensions

    # This extension provides a {ResponseBody#to_ansi} method for the Elasticsearch response body,
    # which colorizes and formats the output with the `ansi` gem.
    #
    # @example Display formatted search results
    #
    #     require 'elasticsearch/extensions/ansi'
    #     puts Elasticsearch::Client.new.search.to_ansi
    #
    # @example Display a table with the output of the `_analyze` API
    #
    #     require 'elasticsearch/extensions/ansi'
    #     puts Elasticsearch::Client.new.indices.analyze(text: 'Quick Brown Fox Jumped').to_ansi
    #
    module ANSI
    end

  end
end

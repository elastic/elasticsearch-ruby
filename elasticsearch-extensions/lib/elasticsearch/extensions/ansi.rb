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

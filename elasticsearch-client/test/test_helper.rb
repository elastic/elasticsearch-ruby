require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["NOTURN"]

require 'elasticsearch-client'

class Test::Unit::TestCase
  def setup
  end

  def teardown
  end
end

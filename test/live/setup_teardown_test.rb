require_relative 'test_helper'

class TestSetupTeardown < Minitest::Test
  def test_can_bootstrap_system
    config = File.read('test/files/system.json')
    uhura = Uhura.new(config)

    uhura.setup
    uhura.teardown
  end
end

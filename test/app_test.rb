require_relative 'test_helper'

class TestApp < Minitest::Test
  def test_has_test_class_declared
    assert App
  end
end

require_relative 'test_helper'

class TestAutoscalingGroup < Minitest::Test
  def test_class_is_defined
    assert AwsAutoscalingGroup
  end
end

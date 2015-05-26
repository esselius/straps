require_relative 'test_helper'

class TestSetupTeardown < Minitest::Test
  def test_can_setup
    region = 'eu-west-1'

    chekov = Chekov.new(File.read(LIVE_TEST_FILE))

    chekov.sqs_client = Aws::SQS::Client.new(region: region)
    chekov.sns_client = Aws::SNS::Client.new(region: region)
    chekov.asg_client = Aws::AutoScaling::Client.new(region: region)

    chekov.setup

    chekov.teardown
  end
end

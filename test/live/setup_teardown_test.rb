require_relative 'test_helper'

class TestSetupTeardown < Minitest::Test
  def test_can_setup
    region = 'eu-west-1'

    # Read config
    @fenix = Fenix.new(LIVE_TEST_FILE)

    # Create aws clients
    asg_client = Aws::AutoScaling::Client.new(region: region)
    sns_client = Aws::SNS::Client.new(region: region)
    sqs_client = Aws::SQS::Client.new(region: region)

    # Instanciate classes
    @unicorn = Unicorn.new(sqs_client, @fenix)
    @hades   = Hades.new(asg_client, @fenix)
    @fairy   = Fairy.new(sns_client, @fenix)

    # Subscribe sqs queue to sns topic
    @unicorn.allow(@fairy.topic_arn)
    @fairy.subscribe('sqs', @unicorn.queue_arn)

    # Setup
    @hades.setup(@fairy.topic_arn)

    # Teardown
    @hades.teardown(@fairy.topic_arn)

    # Unsubscribe and delete sqs queue and sns topic
    @fairy.unsubscribe(@unicorn.queue_arn)
    @fairy.delete
    @unicorn.delete
  end
end

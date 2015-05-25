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
    @hades   = Hades.new(asg_client, @fenix)
    @fairy   = Fairy.new(sns_client, @fenix)
    @unicorn = Unicorn.new(sqs_client, @fenix)

    # Subscribe sqs queue to sns topic
    @fairy.subscribe('sqs', @unicorn.arn)

    # Setup
    @hades.setup(@fairy.arn)

    # Teardown
    #@hades.teardown(@fairy.arn)

    # Unsubscribe and delete sqs queue and sns topic
    #@fairy.unsubscribe(@unicorn.arn)
    #@fairy.delete
    #@unicorn.delete
  end
end

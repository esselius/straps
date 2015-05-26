class Chekov
  include Concord.new(:raw_data)

  attr_accessor :sqs_client, :sns_client, :asg_client

  def data
    @data ||= Fenix.new(JSON.parse(raw_data))
  end

  def queue
    @queue ||= Unicorn.new(sqs_client, data)
  end

  def topic
    @topic ||= Fairy.new(sns_client, data)
  end

  def bootstrapper
    @bootstrapper ||= Hades.new(asg_client, data)
  end

  def setup
    queue.allow(topic.topic_arn)
    topic.subscribe('sqs', queue.queue_arn)

    bootstrapper.setup(topic.topic_arn)
  end

  def teardown
    bootstrapper.teardown(topic.topic_arn)

    topic.unsubscribe(queue.queue_arn)
    topic.delete
    queue.delete
  end
end

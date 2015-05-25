class Fairy
  attr_reader :client, :config

  def initialize(client, config)
    @client = client
    @config = config
    @topic = client.create_topic( name: config.prefix )
  end

  def topic_arn
    @topic[:topic_arn]
  end

  def subscribe(protocol, endpoint)
    client.subscribe(
      topic_arn: topic_arn,
      protocol: protocol,
      endpoint: endpoint
    )
  end

  def unsubscribe(arn)
    client.unsubscribe(
      subscription_arn: arn
    )
  rescue Aws::SNS::Errors::InvalidParameter
  end

  def delete
    client.delete_topic( topic_arn: topic_arn )
  end
end

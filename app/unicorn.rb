class Unicorn
  attr_reader :client

  def initialize(client, config)
    @client = client
    @queue = client.create_queue( queue_name: config.prefix )
  end

  def url
    @url ||= @queue[:queue_url]
  end

  def arn
    @arn ||= client.get_queue_attributes(
      queue_url: url,
      attribute_names: ['QueueArn']
    )[:attributes].fetch('QueueArn')
  end

  def delete
    client.delete_queue( queue_url: url )
  end
end

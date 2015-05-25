class Unicorn
  attr_reader :client

  def initialize(client, config)
    @client = client
    @queue = client.create_queue( queue_name: config.prefix )
  end

  def url
    @url ||= @queue[:queue_url]
  end

  def queue_arn
    @queue_arn ||= client.get_queue_attributes(
      queue_url: url,
      attribute_names: ['QueueArn']
    )[:attributes].fetch('QueueArn')
  end

  def allow(arn)
    policy = {
      Version: "2012-10-17",
      Statement: [
        {
          Sid: "MySQSPolicy001",
          Effect: "Allow",
          Principal: "*",
          Action: "sqs:SendMessage",
          Resource: queue_arn,
          Condition: {
            ArnEquals: {
              "aws:SourceArn" => arn
            }
          }
        }
      ]
    }.to_json

    client.set_queue_attributes(
      queue_url: url,
      attributes: {
        'Policy' => policy
      }
    )
  end

  def delete
    client.delete_queue( queue_url: url )
  end
end

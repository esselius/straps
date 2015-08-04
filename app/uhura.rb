class Uhura
  include Concord.new(:raw_data)

  def data
    @data ||= JSON.parse(raw_data)
  end

  def regions
    data.fetch('regions')
  end

  def prefix
    data.fetch('prefix')
  end

  def containers
    data.fetch('containers', [])
  end

  def queue(region)
    Unicorn.new(App.client.sqs(region: region), data)
  end

  def topic(region)
    Fairy.new(App.client.sns(region: region), data)
  end

  def bootstrapper(region, container)
    Hades.new(App.client.asg(region: region), container)
  end

  def setup
    regions.each do |region|
      queue(region).allow(topic(region).topic_arn)
      topic(region).subscribe('sqs', queue(region).queue_arn)

      containers.each do |container|
        bootstrapper(region, container).setup(topic(region).topic_arn)
      end
    end
  end

  def teardown
    regions.each do |region|
      containers.each do |container|
        bootstrapper(region, container).teardown(topic(region).topic_arn)
      end

      topic(region).unsubscribe(queue(region).queue_arn)
      topic(region).delete
      queue(region).delete
    end
  end
end

class Fairy
  include Concord.new(:client, :config)

  def arn
    @arn ||= client.create_topic( name: config.prefix )[:topic_arn]
  end
end

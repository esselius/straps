class Hades
  include Concord.new(:client, :config)

  def setup(topic)
    config.each do |group|
      lc = AwsLaunchConfiguration.new(group)
      create_lc(lc.config)

      asg = AwsAutoscalingGroup.new(group, lc)
      create_asg(asg.config)

      configure_asg_notifications(asg.config, topic)
    end
  end

  def teardown(topic)
    config.each do |group|
      lc = AwsLaunchConfiguration.new(group)
      asg = AwsAutoscalingGroup.new(group, lc)

      remove_asg_notifications(asg.config, topic)
      remove_asg(asg.config)
      remove_lc(lc.config)
    end
  end

  private

  def create_lc(config)
    client.create_launch_configuration(config)
  rescue Aws::AutoScaling::Errors::AlreadyExists
  end

  def remove_lc(config)
    client.delete_launch_configuration(
      launch_configuration_name: config[:launch_configuration_name]
    )
  end

  def create_asg(config)
    client.create_auto_scaling_group(config)
  rescue Aws::AutoScaling::Errors::AlreadyExists
  end

  def remove_asg(config)
    client.delete_auto_scaling_group(
      auto_scaling_group_name: config[:auto_scaling_group_name],
      force_delete: true
    )
  end

  def configure_asg_notifications(config, topic_arn)
    client.put_notification_configuration({
        auto_scaling_group_name: config[:auto_scaling_group_name],
        topic_arn: topic_arn,
        notification_types: [
          "autoscaling:EC2_INSTANCE_LAUNCH",
          "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
          "autoscaling:EC2_INSTANCE_TERMINATE",
          "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
          "autoscaling:TEST_NOTIFICATION"
        ]
      })
  end

  def remove_asg_notifications(config, topic_arn)
    client.delete_notification_configuration(
      auto_scaling_group_name: config[:auto_scaling_group_name],
      topic_arn: topic_arn
    )
  end
end

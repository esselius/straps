class AwsLaunchConfiguration
  include Concord.new(:options)

  def name
    options.fetch('name')
  end

  def ami
    options.fetch('ami')
  end

  def instance_type
    options.fetch('instance_type')
  end

  def config
    config = {}
    config[:launch_configuration_name] = name
    config[:image_id] = ami
    config[:instance_type] = instance_type
    config
  end
end

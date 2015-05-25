class AwsAutoscalingGroup
  include Concord.new(:options, :lc)

  def name
    options.fetch('name')
  end

  def min
    options.fetch('min', 1)
  end

  def max
    options.fetch('max', 10)
  end

  def availability_zones
    ['eu-west-1a']
  end

  def config
    config = {}
    config[:auto_scaling_group_name] = name
    config[:min_size] = min
    config[:max_size] = max
    config[:availability_zones] = availability_zones
    config[:launch_configuration_name] = lc.name
    config
  end
end

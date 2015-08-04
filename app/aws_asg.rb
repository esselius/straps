class AwsAutoscalingGroup
  include Concord.new(:region, :options, :lc)

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
    case region
    when 'eu-west-1'
      ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']
    when 'eu-central-1'
      ['eu-central-1a', 'eu-central-1b']
    end
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

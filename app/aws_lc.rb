class AwsLaunchConfiguration
  include Concord.new(:region, :options)

  def name
    options.fetch('name')
  end

  def ami
    case region
    when 'eu-west-1'
      'ami-cf7a12b8'
    when 'eu-central-1'
      'ami-5ac5fa47'
    end
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

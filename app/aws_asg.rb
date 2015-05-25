class AwsAutoscalingGroup
  include Concord.new(:name)

  attr_accessor :min, :max, :launch_config
end

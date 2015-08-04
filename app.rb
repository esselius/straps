require 'concord'
require 'aws-sdk'

require 'singleton'
require 'json'

# Aws Config Translator classes
require_relative 'app/aws_asg'
require_relative 'app/aws_lc'

# Aws Service classes
require_relative 'app/hades'
require_relative 'app/fairy'
require_relative 'app/unicorn'

# Orchestrator classes
require_relative 'app/uhura'

module App
  class Client
    include Singleton

    def sqs(options)
      Aws::SQS::Client.new(aws_options(options))
    end

    def sns(options)
      Aws::SNS::Client.new(aws_options(options))
    end

    def asg(options)
      Aws::AutoScaling::Client.new(aws_options(options))
    end

    def aws_options(options)
      case ENV.fetch('ENVIRONMENT', 'test')
      when 'production'
        options
      when 'test'
        options.merge({ stub_responses: true })
      end
    end
  end

  class << self
    def client
      Client.instance
    end
  end
end

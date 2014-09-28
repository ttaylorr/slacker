require 'aws-sdk'

module Slacker
  class AwsListMaintenance < Plugin

    def help
      "#{SLACKER_NAME_OVERRIDE} aws maintenace"
    end

    def pattern
      /aws maintenance/i
    end

    def respond (text, user_name, channel_name, timestamp)
      AWS.config(
        :access_key_id     => ENV.fetch('AWS_ACCESS_KEY_ID'),
        :secret_access_key => ENV.fetch('AWS_SECRET_KEY_ID'))

      output = "Summary\n"

      ec2 = AWS.ec2

      api_result = ec2.client.describe_instance_status

      api_result.instance_status_set.each { |instance|
        instance.events_set && instance.events_set.each { |event|
          output << "#{ec2.instances[instance.instance_id].tags["Name"]} (#{instance.instance_id} #{instance.availability_zone}) - #{event.description}, Not Before: #{event.not_before}, Not After: #{event.not_after}\n"
        }
      }

      output
    end

    Bot.register(AwsListMaintenance)
  end
end

require 'net/http'
require 'openssl'
require 'json'

module Slacker
  class RabbitMQ < Plugin
    def help
      'Usage: slacker rabbitmq <environment>'
    end

    def pattern
      /rabbitmq/i
    end

    def respond (text, user_name, channel_name, timestamp)
      action, slacker, environment, *_ = text.split(" ")

      case environment
      when 'production'
        host     = ENV.fetch('RABBITMQ_PRODUCTION_IP')
        username = ENV.fetch('RABBITMQ_PRODUCTION_USERNAME')
        password = ENV.fetch('RABBITMQ_PRODUCTION_PASSWORD')
      when 'staging1'
        host     = ENV.fetch('RABBITMQ_STAGING1_IP')
        username = ENV.fetch('RABBITMQ_STAGING1_USERNAME')
        password = ENV.fetch('RABBITMQ_STAGING1_PASSWORD')
      when 'staging2'
        host     = ENV.fetch('RABBITMQ_STAGING2_IP')
        username = ENV.fetch('RABBITMQ_STAGING2_USERNAME')
        password = ENV.fetch('RABBITMQ_STAGING2_PASSWORD')
      when 'staging3'
        host     = ENV.fetch('RABBITMQ_STAGING3_IP')
        username = ENV.fetch('RABBITMQ_STAGING3_USERNAME')
        password = ENV.fetch('RABBITMQ_STAGING3_PASSWORD')
      when 'sandbox'
        host     = ENV.fetch('RABBITMQ_SANDBOX_IP')
        username = ENV.fetch('RABBITMQ_SANDBOX_USERNAME')
        password = ENV.fetch('RABBITMQ_SANDBOX_PASSWORD')
      end


      if VALID_ENVIRONMENTS.include?(environment) then
        req = Net::HTTP::Get.new "/api/queues"

        req.basic_auth username, password

        http_opts = { use_ssl: false }

        res = Net::HTTP.start host, 15672, http_opts do |https|
          https.request req
        end

        results = JSON.parse res.body

        output = "Summary\n"

        results.each_with_index do |result,i|
          if i > 1
            queue_name = result["name"]
            queue_messages = result["messages"]
            queue_messages_ready = result["messages_ready"]
            queue_messages_unacknowledged = result["messages_unacknowledged"]
            queue_idle_since = result["idle_since"]
            output << "#{queue_name}, Ready #{queue_messages_ready}, UnAck #{queue_messages_unacknowledged}, Messages #{queue_messages}, Idle Since #{queue_idle_since}\n"
          end
        end
      else
        output = "Put in a correct environment you douche! #{VALID_ENVIRONMENTS}"
      end
      output
    end

    Bot.register(RabbitMQ)
  end
end

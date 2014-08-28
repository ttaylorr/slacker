require 'net/http'
require 'openssl'
require 'json'

module Slacker
  class DeadmanSnitch < Plugin
    def help
      'Usage: slacker rabbitmq <environment>'
    end

    def pattern
      /deadmansntich/i
    end

    def respond (text, user_name, channel_name, timestamp)
      req = Net::HTTP::Get.new "/v1/snitches"

      req.basic_auth ENV.fetch('DEADMANSNITCH_API')

      http_opts = { use_ssl: false }

      res = Net::HTTP.start 'api.deadmanssnitch.com', 443, http_opts do |https|
        https.request req
      end

      results = JSON.parse res.body

      output = "Summary\n\n"

      results.each do |result|
        snitch_name = result["name"]
        snitch_status = result["status"]
        output << "#{snitch_name} - #{snitch_status}\n"
      end
      output
    end

    Bot.register(DeadmanSnitch)
  end
end

require 'net/http'
require 'openssl'
require 'json'

module Slacker

  VALID_ENVIRONMENTS = %w(production dev test staging)

  class DelayedJob < Plugin
    def help
      'Usage: slacker dj'
    end

    def pattern
      /dj/i
    end

    def respond (text, user_name, channel_name, timestamp)
      environment = text.split(" ").last
      environment = "production" unless VALID_ENVIRONMENTS.include?(environment)

      req = Net::HTTP::Get.new "/v1/metrics/#{environment}.delayed_job.total?count=1&resolution=1"

      req.basic_auth ENV.fetch('LIBRATO_USERNAME'), ENV.fetch('LIBRATO_PASSWORD')

      http_opts = { use_ssl: true }

      res = Net::HTTP.start 'metrics-api.librato.com', 443, http_opts do |https|
        https.request req
      end

      result = JSON.parse res.body
      delayed_job_count = result["measurements"].first.last.first["value"]
      time_date = Time.at result["measurements"].first.last.first["measure_time"]

      "#{environment} - #{delayed_job_count} at #{time_date}"
    end

    Bot.register(DelayedJob)
  end
end

require_relative '../http/generic_http_client'

module Slacker
  module Adapters
    class SlackHttpClient < Http::GenericHttpClient
      def initialize(name, token)
        super("https://slack.com/api/")

        @name, @token =
          name, token
      end

      def start_rtm
        response = json_parse self.get('rtm.start', {
          :token => @token
        })
        raise "Invalid Slack authentication" if response["error"] == "invalid_auth"
        response
      end
    end
  end
end

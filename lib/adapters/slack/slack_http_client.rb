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
        json_parse self.get('rtm.start', {
          :token => @token
        })
      end
    end
  end
end

require_relative '../http/generic_http_client'

module Slacker
  module Adapters
    class SlackHttpClient < Http::GenericHttpClient
      def initialize(token, username)
        super("https://slack.com/api/")

        @token, @username = token, username
      end

      def group_history(channel, oldest=0, count=100)
        json_parse self.get('groups.history', {
          :token => @token,
          :channel => channel,
          :oldest => oldest.to_i,
          :count => count
        })
      end

      def post_message(channel, text, icon)
        json_parse self.post('chat.postMessage', {
          :token => @token,
          :channel => channel,
          :text => text,
          :username => @username,
          :icon => icon
        })
      end
    end
  end
end

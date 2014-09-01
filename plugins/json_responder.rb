require 'excon'
require 'json'

module Slacker
  module JSONResponder
    def read_json(url)
      response = Excon.get url

      JSON.parse response.body
    end

    def respond (text, user_name, channel_name, timestamp)

      url = url_for
      result = read_json(url)

      process_response result
    end
  end
end

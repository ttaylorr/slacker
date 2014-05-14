module Slacker
  class WhoAmI < Plugin

    def pattern
      /who\s?am\s?i\s?/
    end

    def respond (text, user_name, channel_name, timestamp)
      'You are ' << user_name << '.'
    end

    Bot.register(WhoAmI)
  end
end

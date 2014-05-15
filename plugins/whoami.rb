module Slacker
  class WhoAmI < Plugin

    def help
      'Who\'s your daddy?'
    end

    def pattern
      /who\s?am\s?i\s?/i
    end

    def respond (text, user_name, channel_name, timestamp)
      'You are ' << user_name << '.'
    end

    Bot.register(WhoAmI)
  end
end

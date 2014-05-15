module Slacker
  class Selfie < Plugin
    def pattern
      /(take\sa\s)?selfie/
    end

    def respond (text, user_name, channel_name, timestamp)
      'http://goo.gl/ck7GoN'
    end

    Bot.register(Selfie)
  end
end

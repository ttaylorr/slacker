module Slacker
  class Selfie < Plugin
    def pattern
      /(take\sa\s)?selfie/
    end

    def respond (text, user_name, channel_name, timestamp)
      'Look, it\'s me! :camera: :sparkles: http://i.imgur.com/tMom4oB.png'
    end

    Bot.register(Selfie)
  end
end

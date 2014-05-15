module Slacker
  class Selfie < Plugin
    def help
      'Usage: slacker take a selfie -> slacker will show you how pretty he is.'
    end

    def pattern
      /(take\sa\s)?selfie/
    end

    def respond (text, user_name, channel_name, timestamp)
      'Look, it\'s me! :camera: :sparkles: http://i.imgur.com/tMom4oB.png'
    end

    Bot.register(Selfie)
  end
end

module Slacker
  class Ping < Plugin
    def help
      'Usage: slacker ping -> I am here!'
    end

    def pattern
      /ping|(are\s(you|u|ya)\sthere)/i
    end

    def respond (text, user_name, channel_name, timestamp)
      'I am here!'
    end

    Bot.register(Ping)
  end
end

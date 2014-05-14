module Slacker
  class Ping < Plugin
    def pattern
      /ping/
    end

    def respond (text, user_name, channel_name, timestamp)
      'pong!'
    end

    Bot.register(Ping)
  end
end

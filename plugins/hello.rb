module Slacker
  class Hello < Plugin
    def help
      'Usage: slacker say hello -> a nice greeting'
    end

    # Squirrels courtesy of Hubot
    @@greetings = [
      "Hello!",
      "Pleased to meet you.",
      "I'm Slacker!"
    ]

    def pattern
      /(say\s(hi|hello))|(introduce\syourself)/
    end

    def respond (text, user_name, channel_name, timestamp)
      @@greetings.sample
    end

    Bot.register(Hello)
  end
end

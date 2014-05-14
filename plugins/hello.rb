module Slacker
  class Hello < Plugin

    # Squirrels courtesy of Hubot
    @@greetings = [
      "Hello!",
      "Pleased to meet you."
      "I'm Slacker!"
    ]

    def pattern
      /(say\shi)|(introduce\syourself)/
    end

    def respond (text, user_name, channel_name, timestamp)
      @@greetings.sample
    end

    Bot.register(Hello)
  end
end

module Slacker
  class Nice < Plugin

    @@aww = [
      'Thank you for installing me!',
      'You are awesome!',
      'I think Overcast Network is the greatest server',
      'You are all excellent people!',
      ':)',
      'Have a great day!'
    ]

    def help
      'Usage: slacker, be nice -> slacker will begrudginly say something kind'
    end

    def pattern
      /be\snice/
    end

    def respond (text, user_name, channel_name, timestamp)
      @@aww.sample
    end

    Bot.register(Nice)
  end
end

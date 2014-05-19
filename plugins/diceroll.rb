module Slacker
  class DiceRoll < Plugin
    def help
      'Usage: slacker roll a dice -> slacker will roll a six-sided dice.'
    end

    def pattern
      /roll\s(a|some)\sdice/
    end

    def respond (text, user_name, channel_name, timestamp)
      result = rand(6) + 1
      return "I rolled a six-sided dice and got... #{result}!"
    end

    Bot.register(DiceRoll)
  end
end

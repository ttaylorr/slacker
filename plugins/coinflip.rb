module Slacker
  class CoinFlip < Plugin

    def pattern
      /(flip\sa\scoin)|(heads\sor\stails)/
    end

    def respond (text, user_name, channel_name, timestamp)
      heads = [true, false].sample
      return 'I get... ' << (heads ? 'heads' : 'tails') << '!'
    end

    Bot.register(CoinFlip)
  end
end

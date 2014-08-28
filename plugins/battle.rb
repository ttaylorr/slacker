require 'google-search'

module Slacker
  class Battle < Plugin
    def help
      'Usage: slacker battle sentinel'
    end

    def pattern
      /battle sentinel/
    end

    def respond (text, user_name, channel_name, timestamp)
      address = pattern.match(text)
      query = 'sword fight'

      images = Google::Search::Image.new(:query => query)

      if images.any?
        image = images.first
        'I am ready, bring it!' << image.uri
      else
        'I couldn\'t find an image of ' << query << ' :('
      end
    end

    Bot.register(Battle)
  end
end

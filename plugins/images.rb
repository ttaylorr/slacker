require 'google-search'

module Slacker
  class Images < Plugin
    def help
      'Usage: slacker image me [query] -> the first image returned from Google Images'
    end

    def pattern
      /image(\s?me)?/
    end

    def respond (text, user_name, channel_name, timestamp)
      address = pattern.match(text)
      query = text[address.end(0)+1..text.length()]

      images = Google::Search::Image.new(:query => query)

      if images.any?
        image = images.first
        'Here\'s an image of \'' << query << "': " << image.uri
      else
        'I couldn\'t find an image of ' << query << ' :('
      end
    end

    Bot.register(Images)
  end
end

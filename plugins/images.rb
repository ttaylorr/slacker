require 'google-search'

module Slacker
  class Images < Plugin

    def pattern
      /image(\s?me)?/
    end

    def respond (text, user_name, channel_name, timestamp)
      address = pattern.match(text)
      query = text[address.end(0)+1..text.length()]

      image = Google::Search::Image.new(:query => query).first
      'Here\'s an image of \'' << query << "': " << image.uri
    end

    Bot.register(Images)
  end
end

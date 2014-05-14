require 'uri'
require 'googl'

module Slacker
  class Shorten < Plugin

    @@responses = [
      'All done!',
      'Easy-peasy!',
      'Here it is:',
      'No problem!'
    ]

    def pattern
      /shorten\s?http/
    end

    def respond (text, user_name, channel_name, timestamp)
      longUrl = text[text.index('http')..text.length()]
      googl = Googl.shorten(longUrl)

      return @@responses.sample + ' ' + googl.short_url 
    end

    Bot.register(Shorten)
  end
end

require 'google-search'

module Slacker
  class GoogleMe < Plugin

    def help
      'Usage: slacker google me [query] -> the first Google web search result'
    end

    def pattern
      /google\sme\s(.*)/i
    end

    def respond (text, user_name, channel_name, timestamp)
      query = pattern.match(text).captures[0]

      results = Google::Search::Web.new(:query => query)
      if results.any?
        'Here\'s something for #{query}: ' << results.first.uri
      else
        'Aww :( I couldn\'t find aynthing matching \'#{query}\''
      end
    end

    Bot.register(GoogleMe)
  end
end

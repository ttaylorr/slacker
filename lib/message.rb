require_relative 'scoped_listener'

module Slacker
  class Message
    attr_reader :text, :original_message, :channel, :user, :response, :response_listeners

    def initialize(text, original_message, channel, user)
      @text, @original_message, @channel, @user, @response, @response_listeners =
        text, original_message, channel, user, [], []
    end

    def write(message)
      @response << message
    end
    alias_method :<<, :write

    def pretty_response
      @response.join("\n")
    end

    def expect_reply(regex, &block)
      @response_listeners << ::Slacker::ScopedListener.new(@user, regex, block)
    end
  end
end

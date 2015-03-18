module Slacker
  class Message
    attr_reader :text, :channel, :user, :response

    def initialize(text, channel, user)
      @text, @channel, @user, @response =
        text, channel, user, []
    end

    def write(message)
      @response << message
    end

    def pretty_response
      @response.join("\n")
    end

    alias_method :<<, :write
  end
end

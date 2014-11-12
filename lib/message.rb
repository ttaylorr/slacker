module Slacker
  class Message
    attr_reader :contents, :response

    def initialize(raw)
      @contents, @response = raw, Array.new
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

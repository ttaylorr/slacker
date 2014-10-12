module Slacker
  class Message
    attr_reader :contents, :response

    def initialize(raw)
      @contents, @response = raw, []
    end

    def write(message)
      @response << message
    end
  end
end

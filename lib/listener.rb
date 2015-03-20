module Slacker
  class Listener
    attr_reader :regex, :callback, :conversational
    attr_writer :conversational

    def initialize(regex, callback)
      @regex, @callback = regex, callback
      @conversational = false
    end

    def hears?(message)
      self.regex.match(message.text)
    end

    def hear!(message, match)
      self.callback.call(message, match)
    end
  end
end

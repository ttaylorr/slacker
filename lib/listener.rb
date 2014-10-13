module Slacker
  class Listener
    attr_reader :regex, :callback

    def initialize(regex, callback)
      @regex, @callback = regex, callback
    end

    def hears?(message)
      self.regex.match(message.contents)
    end

    def hear!(message, match)
      self.callback.call(message, match)
    end
  end
end

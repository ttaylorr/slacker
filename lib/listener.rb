module Slacker
  class Listener
    attr_reader :regex, :callback

    def initialize(regex, callback)
      @regex, @callback = regex, callback
    end

    def hears?(message)
      !self.regex.match(message.contents).nil?
    end

    def hear!(message)
      self.callback.call(message)
    end
  end
end

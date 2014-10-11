module Slacker
  class Listener
    attr_reader :regex, :callback

    def initialize(regex, callback)
      @regex, @callback = regex, callback
    end

    def hears?(message_data)
      !self.regex.match(message_data).nil?
    end

    def hear!(message_data)
      self.callback.call(message_data)
    end
  end
end

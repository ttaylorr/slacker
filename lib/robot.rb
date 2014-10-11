require_relative 'listener'

module Slacker
  class Robot
    def initialize
      @listeners = []
    end

    def respond(regex, &callback)
      @listeners << Listener.new(regex, callback)
    end

    def hear(message_data)
      @listeners.each do |listener|
        if listener.hears?(message_data)
          listener.hear!(message_data)
        end
      end
    end
  end
end

require_relative 'listener'
require_relative 'message'

module Slacker
  class Robot
    def initialize
      @listeners = []
    end

    def respond(regex, &callback)
      @listeners << Listener.new(regex, callback)
    end

    def hear(raw_message)
      message = Message.new(raw_message)

      @listeners.each do |listener|
        if listener.hears?(message)
          listener.hear!(message)
        end
      end

      message
    end

    def attach(adapter)
      (Thread.new { adapter.run }).join
    end

    def plug(plugin)
      plugin.ready(self)
    end
  end
end

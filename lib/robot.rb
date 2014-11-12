require_relative 'listener'
require_relative 'message'

module Slacker
  class Robot
    def initialize
      @listeners, @adapter = [], nil
    end

    def respond(regex, &callback)
      @listeners << Listener.new(regex, callback)
    end

    def hear(raw_message)
      message = Message.new(raw_message)

      @listeners.each do |listener|
        match = listener.hears?(message)
        if match
          listener.hear!(message, match)
        end
      end

      @adapter.send(message) unless @adapter.nil?

      return message
    end

    def attach(adapter)
      @adapter = adapter
      
      begin
        (Thread.new { adapter.run }).join
      rescue Exception => e
        puts e
      end
    end

    def plug(plugin)
      plugin.ready(self)
    end
  end
end

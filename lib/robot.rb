require_relative 'listener'
require_relative 'message'

module Slacker
  class Robot
    attr_reader :name

    def initialize(name)
      @name, @listeners, @adapter = (name || ENV["NAME"]), [], nil
    end

    def respond(regex, &callback)
      @listeners << Listener.new(regex, callback)
    end

    def address_pattern
      /^((#{@name}[:,]?)|\/)\s*/
    end

    def hear(raw_message)
      return unless raw_message =~ address_pattern
      message = Message.new(raw_message.gsub(address_pattern, ""))

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

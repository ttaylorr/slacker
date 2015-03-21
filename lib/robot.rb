require_relative 'listener'
require_relative 'message'

require 'redis'
require 'redis-namespace'
require 'colorize'

module Slacker
  class Robot
    attr_reader :name, :redis, :adapter

    def initialize(name)
      @name, @listeners, @adapter =
        (name || ENV["NAME"]), [], nil

      redis_connection = Redis.new(:host => (ENV["REDIS_HOST"] || "127.0.0.1"),
                                   :port => (ENV["REDIS_PORT"] || 6739))
      @redis = Redis::Namespace.new(:ns => :slacker, :redis => redis_connection)
    end

    def respond(regex, &callback)
      @listeners << Listener.new(regex, callback)
    end

    def address_pattern
      /^@?(#{@name})[:-;\s]?/
    end

    def hear(raw_message)
      original_text = raw_message[:text]
      message = Message.new(original_text.gsub(address_pattern, ""),
                            original_text,
                            raw_message[:channel],
                            raw_message[:user])

      # Duplicate the @listeners array so we can drop all of the conversational listeners
      # if they've been satisfied
      @listeners.dup.each do |listener|
        match = listener.hears?(message)

        if match && (listener.conversational ? true : message.original_message =~ address_pattern)
          listener.hear!(message, match)

          # If there is a match and the listener is conversational, we can delete it because
          # it has been satisfied
          if listener.conversational
            @listeners.delete(listener)
          end
        end
      end

      # Add all of the response listeners to the message
      @listeners = (@listeners + message.response_listeners)

      @adapter.send(message) if @adapter

      return message
    end

    def send_message(reply, channel)
      message = Message.new(nil, nil, channel, nil)
      message << reply

      @adapter.send(message)
    end

    def attach(adapter)
      @adapter = adapter

      begin
        (Thread.new { adapter.run }).join
      rescue Exception => e
        puts e.message
      end
    end

    def plug(plugin)
      plugin.ready(self)
    end
  end
end

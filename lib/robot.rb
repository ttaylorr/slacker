require_relative 'listener'
require_relative 'message'

require 'colorize'

module Slacker
  class Robot
    attr_reader :name

    def initialize
      ["         __           __               ",
       "   _____/ /___ ______/ /_____  _____   ",
       "  / ___/ / __ `/ ___/ //_/ _ \\/ ___/  ",
       " (__  ) / /_/ / /__/ ,< /  __/ /       ",
       "/____/_/\\__,_/\\___/_/|_|\\___/_/     ",
       "",                                      ].each do |segment|
        puts segment.green
      end

      @name, @listeners, @adapter =
        ENV["NAME"], [], nil
    end

    def respond(regex, &callback)
      @listeners << Listener.new(regex, callback)
    end

    def address_pattern
      /^@?(#{@name})[:-;\s]?/
    end

    def hear(raw_message)
      text = raw_message[:text]

      log_args = ["#{Time.now.to_s.blue}", " - ".red, raw_message[:user]["name"].green,
                  " said \"".red, raw_message[:text].green, "\"".red]

      if raw_message[:channel]["name"]
        log_args << " in ".red
        log_args << "##{raw_message[:channel]["name"]}".green
      end

      puts log_args.join

      return unless text =~ address_pattern
      message = Message.new(text.gsub(address_pattern, ""),
                            raw_message[:channel],
                            raw_message[:user])

      @listeners.each do |listener|
        match = listener.hears?(message)
        if match
          listener.hear!(message, match)
        end
      end

      @adapter.send(message) if @adapter

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

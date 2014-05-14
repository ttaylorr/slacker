require 'rubygems'
require 'sinatra'
require 'json'

post '/' do
  content_type :json

  text = params[:text]
  user_name = params[:user_name]
  channel_name = params[:channel_name]
  timestamp = params[:timestamp]

  response = Slacker::Bot.handle(text, user_name, channel_name, timestamp)
  JSON.generate({text: response}) if response
end

get '/' do
  content_type :json
  JSON.generate({text: 'Hello from Slacker!'})
end

module Slacker
  class Bot
    @@plugins = Array.new

    class <<self
      def plugins
        @@plugins
      end

      def register(plugin)
        @@plugins << plugin.new
      end

      def handle(text, user_name, channel_name, timestamp)
        response = Array.new

        @@plugins.each do |plugin|
          if plugin.pattern =~ text
            response << plugin.respond(text, user_name, channel_name, timestamp)
          end
        end

        return response
      end
    end 
  end

  class Plugin
    def pattern
      //
    end

    def handle(text, user_name, channel_name, timestamp)
      ''
    end
  end

  Dir.glob('plugins/**/*.rb').each do |f|
    load f
  end
end


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
  JSON.generate({text: response.join("\n")}) if response
end

get '/' do
  haml :index
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
            r = plugin.respond(text, user_name, channel_name, timestamp)
            response << r unless r.nil?
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


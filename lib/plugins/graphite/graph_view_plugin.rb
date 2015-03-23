require 'dotenv'
require 'json'
require "open-uri"

require_relative '../../imgur/imgur'

module Slacker
  class GraphViewPlugin
    def initialize
      @api_host = ENV["GRAPHITE_API_HOST"]
      @api_port = ENV["GRAPHITE_API_PORT"]

      @imgur = ENV["IMGUR_CLIENT_ID"] ? Imgur.new(ENV["IMGUR_CLIENT_ID"]) : nil
    end

    def ready(robot)
      robot.respond /graph me (.*)/ do |message, match|
        graphite_url = graph_image_url(match[1])

        message << "Okay, graphed that for you :chart_with_upwards_trend:"

        if @imgur.nil?
          # If we're not re-hosting images, just send the link directly
          message << graphite_url
        else
          # Otherwise, do four things, in this order:
          #   1) download the image data ourselves
          #   2) upload it to imgur
          #   3) queue a delete job
          #   4) send the imgur link into chat

          image_data = open(graphite_url).read
          image = @imgur.post_image(image_data)

          # Queue up a job to delete the image after a certain period of time
          delete_after(image["data"]["deletehash"], ENV["IMGUR_DELETE_AFTER"].to_i)

          message << "https://i.imgur.com/#{image["data"]["id"]}.png"
        end
      end
    end

    private
    def graph_image_url(target)
      "http://#{@api_host}:#{@api_port}/render?target=#{target}.png"
    end

    def delete_after(delete_hash, wait_time)
      Thread.new do
        sleep wait_time
        @imgur.delete_image(delete_hash)
      end
    end
  end
end

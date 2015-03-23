require 'dotenv'
require 'json'
require "open-uri"

require_relative '../../imgur/imgur'

module Slacker
  class GraphViewPlugin
    def initialize(graphite_api)
      @graphite_api = graphite_api
      @imgur = ENV["IMGUR_CLIENT_ID"] ? Imgur.new(ENV["IMGUR_CLIENT_ID"]) : nil
    end

    def ready(robot)
      robot.respond /(?:(?:graph me)|(?:(?:show|get|fetch) me a graph of)) (.*)/ do |message, match|
        graph_id = match[1]
        graphite_url = @graphite_api.graph_url_for graph_id

        message << "Okay, here's a graph of `#{graph_id}` for you! :chart_with_upwards_trend:"

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
    def delete_after(delete_hash, wait_time)
      Thread.new do
        sleep wait_time
        @imgur.delete_image(delete_hash)
      end
    end
  end
end

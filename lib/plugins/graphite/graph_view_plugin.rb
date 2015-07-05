require 'dotenv'
require 'json'
require "open-uri"
require "s3"

require_relative '../../imgur/imgur'

module Slacker
  class GraphViewPlugin
    def initialize(graphite_api)
      @graphite_api = graphite_api
    end

    def ready(robot)
      robot.respond /(?:(?:graph me)|(?:(?:show|get|fetch) me a graph of)) (.*)/ do |message, match|
        graph_id = match[1]
        graphite_url = @graphite_api.graph_url_for graph_id

        message << "Okay, here's a graph of `#{graph_id}` for you! :chart_with_upwards_trend:"

        if storage_bucket.nil?
          # If we're not re-hosting images, just send the link directly
          message << graphite_url
        else
          # Otherwise, do these things things, in this order:
          #   1) download the image data ourselves
          #   2) place the data into the bucket
          #   3) send the bucket-link into chat
          bucket = storage_bucket
          img_name = "graphs/#{graph_object_name}.png"

          object = bucket.objects.build(img_name)
          object.content = open(graphite_url).read
          object.save

          message << "https://s3.amazonaws.com/#{ENV['S3_BUCKET_NANE']}/#{img_name}"
        end
      end
    end

    private
    def storage_bucket
      @s3 ||= S3::Service.new(:access_key_id => ENV['S3_ACCESS_KEY_ID']
                            :secret_access_key => ENV['S3_SECRET_KEY'])
      @s3.buckets.find(ENV['S3_BUCKET_NAME'] unless @s3.nil?
    end

    def graph_object_name
      return "graph:#{Time.now.to_i}"
    end
  end
end

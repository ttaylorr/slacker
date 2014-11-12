require 'uri'
require 'net/http'
require 'json'
require 'openssl'

module Slacker
  module Adapters
    module Http
      class GenericHttpClient
        def initialize(base_path)
          @root = URI.parse(base_path)
          @http = Net::HTTP.new(@root.host, @root.port)

          @http.use_ssl = true
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        def get(relative_path, args)
          uri = URI.join(@root, relative_path)
          uri.query = URI.encode_www_form(args) unless args.nil?

          request = Net::HTTP::Get.new(uri)

          @http.request(request)
        end

        def post(relative_path, args)
          request = Net::HTTP::Post.new(URI.join(@root, relative_path))
          request.set_form_data(args) unless args.nil?

          @http.request(request)
        end

        def json_parse(response)
          JSON.parse(response.body)
        end
      end
    end
  end
end

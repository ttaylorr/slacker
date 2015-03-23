require 'net/http'
require 'json'

class GraphiteAPI
  def initialize(host, port)
    @uri = URI.parse("https://#{host}:#{port}")
    @graphite = Net::HTTP.new(@uri.host, @uri.port)
  end

  def expand(query)
    get("metrics/expand", {:query => query})["results"]
  end

  private
  def get(endpoint, data)
    request_uri = @uri.merge(endpoint)
    request_uri.query = URI.encode_www_form(data)

    request = Net::HTTP::Get.new(request_uri)

    get_json_from request
  end

  def get_json_from(request)
    JSON.parse(@graphite.request(request).body)
  end
end

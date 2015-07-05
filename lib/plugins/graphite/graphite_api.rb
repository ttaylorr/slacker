require 'net/http'
require 'json'
require 'uri'

class GraphiteAPI
  def initialize(host, port)
    @uri = URI.parse("http://#{host}:#{port}")
    @graphite = Net::HTTP.new(@uri.host, @uri.port)
  end

  def graph_url_for(id)
    "#{@uri.to_s}/render?target=#{id}.png&width=1000&height=300"
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

class Imgur
  def initialize(client_id)
    @client_id = client_id

    @uri = URI.parse("https://api.imgur.com/3/")
    @https = Net::HTTP.new(@uri.host, @uri.port)
    @https.use_ssl = true
    @https.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def post_image(image_data)
    JSON.parse(post("upload", {:image => image_data}).body)
  end

  def delete_image(delete_hash)
    JSON.parse(delete("image/#{delete_hash}").body)
  end

  private
  def post(endpoint, data)
    request = Net::HTTP::Post.new(@uri.merge(endpoint))
    request.set_form_data(data)

    make_request(request)
  end

  def delete(endpoint)
    make_request(Net::HTTP::Delete.new(@uri.merge(endpoint)))
  end

  def make_request(request)
    request.add_field "Authorization", "Client-ID #{@client_id}"
    @https.request(request)
  end
end

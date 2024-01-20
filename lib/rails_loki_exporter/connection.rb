require 'json'
require 'net/http'
require 'uri'

module RailsLokiExporter
  module Connection
    def initialize(base_url, user_name, password, auth_enabled)
      uri = URI.parse(base_url)
      @base_url = uri
      @user_name = user_name
      @password = password
      @auth_enabled = auth_enabled
    end
    def connection
      http = Net::HTTP.new(@base_url.to_s, @base_url.port)
      http.use_ssl = @base_url.scheme == 'https'
      http.read_timeout = 30 # Adjust as needed
      http.open_timeout = 30 # Adjust as needed
      http
    end
    def post(url_loki, body)
      url = @base_url.to_s + url_loki
      username = @user_name
      password = @password
      send_authenticated_post(url, body, username, password)
    end
    def send_authenticated_post(url, body, username, password)
      uri = URI.parse(url)
      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request.body = body

      if username && password && @auth_enabled
        request.basic_auth(username, password)
      else
        raise "Username or password is nil."
      end

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        raise "Failed to make POST request. Response code: #{response.code}, Response body: #{response.body}"
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
    def base64_encode_credentials(user_name, password)
      credentials = "#{user_name}:#{password}"
      Base64.strict_encode64(credentials)
    end
  end
end

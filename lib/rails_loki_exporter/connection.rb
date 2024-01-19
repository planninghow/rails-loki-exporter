module RailsLokiExporter
  module Connection
    def self.create(base_url, user_name, password, auth_enabled)
      new(base_url, user_name, password, auth_enabled).connection
    end

    def initialize(base_url, user_name, password, auth_enabled)
      @base_url = base_url
      @user_name = user_name
      @password = password
      @auth_enabled = auth_enabled
    end
    def connection
      Faraday.new(options) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.request :json # Add this line to log request details
        faraday.response :logger # Add this line to log response details to console
        faraday.response :json, content_type: /\bjson$/ # Assume JSON response
        faraday.request :url_encoded
      end
    end

    def post(url, body)
      response = connection.post(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = JSON.generate(body)
      end

      if response.success?
        JSON.parse(response.body)
      else
        raise "Failed to make POST request. Response code: #{response.status}, Response body: #{response.body}"
      end
    end

    def base64_encode_credentials(user_name, password)
      credentials = "#{user_name}:#{password}"
      Base64.strict_encode64(credentials)
    end
    def options
      headers = {
        accept: 'application/json',
        'Content-Type' => 'application/json',
      }
      headers['Authorization'] = "Basic #{base64_encode_credentials(@user_name, @password)}" if @auth_enabled
      {
        url: @base_url,
        headers: headers
      }
    end
  end
end 

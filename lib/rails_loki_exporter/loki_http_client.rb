require 'socket'
require 'json'
require 'net/http'
require 'uri'

module RailsLokiExporter
  LOGS_TYPE = %w(ERROR WARN FATAL INFO DEBUG).freeze

  class LokiHttpClient

    def initialize(config)
      uri = URI.parse(config['base_url'])
      @base_url =       uri
      @log_file_path =  config['log_file_path']
      @logs_type =      config['logs_type']
      @intercept_logs = config['intercept_logs']
      @job_name =       config['job_name'] || "#{$0}_#{Process.pid}"
      @host_name =      config['host_name'] || Socket.gethostname
      @user_name =      config['user_name']
      @password =       config['password']
      @auth_enabled =   config['auth_enabled']
      @log_buffer = []
      @last_interaction_time = nil
      @interaction_interval = (config['interaction_interval'] || '5').to_i     # in seconds, adjust as needed
      @max_buffer_size =      (config['max_buffer_size'] || '100').to_i        # set the maximum number of logs to buffer

      http = Net::HTTP.new(@base_url.to_s, @base_url.port)
      http.use_ssl = @base_url.scheme == 'https'
      http.read_timeout = 30
      http.open_timeout = 30
      http
    end

    def send_log(log_message)
        @log_buffer << log_message
        if @log_buffer.size >= @max_buffer_size || can_send_log?
          send_buffered_logs
          @last_interaction_time = Time.now
        else
          # @logger.info('Log buffered. Waiting for more logs or interaction interval.')
        end
    end

    private
    def send_buffered_logs
      return if @log_buffer.empty?

      curr_datetime = Time.now.to_i * 1_000_000_000
      msg = "On server #{@host_name} detected error"
      payload = {
        'streams' => [
          { 'stream' => {
            'job' => @job_name,
            'host' => @host_name },
            'values' => @log_buffer.map { |log| [curr_datetime.to_s, log] }}
        ]
      }

      json_payload = JSON.generate(payload)
      uri = '/loki/api/v1/push'
      post(uri, json_payload)

      @log_buffer.clear
    end

    def can_send_log?
      return true if @last_interaction_time.nil?

      elapsed_time = Time.now - @last_interaction_time
      elapsed_time >= @interaction_interval
    end

    def match_logs_type?(log_line)
      return false if log_line.nil?

      type_match = log_line.match(/(ERROR|WARN|FATAL|INFO|DEBUG)/)
      type = type_match ? type_match.to_s : 'UNMATCHED'
      type == 'UNMATCHED' || @logs_type.include?(type)
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
  
      case response
      when Net::HTTPSuccess
        response.body ? JSON.parse(response.body) : nil
      when Net::HTTPNoContent
        puts "Request successful, but no content was returned."
        nil
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
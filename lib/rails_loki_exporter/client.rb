module RailsLokiExporter
  LOGS_TYPE = %w(ERROR WARN FATAL INFO DEBUG).freeze

  class Client
    include RailsLokiExporter::Connection

    attr_accessor :job_name
    attr_accessor :host_name
    attr_accessor :max_buffer_size
    attr_accessor :interaction_interval
    attr_accessor :logger
    attr_accessor :connection

    def initialize(config)
      @base_url = config['base_url']
      @log_file_path = config['log_file_path']
      @logs_type = config['logs_type']
      @intercept_logs = config['intercept_logs']
      @job_name = "job name"
      @host_name = "host name"
      @log_buffer = []
      @last_interaction_time = nil
      @interaction_interval = 1 # in seconds, adjust as needed
      @max_buffer_size = 10 # set the maximum number of logs to buffer
      @logger = InterceptingLogger.new(intercept_logs: @intercept_logs)
      @logger.client = self
      @connection = connection
    end

    def send_all_logs
      File.open(@log_file_path, 'r') do |file|
        file.each_line do |line|
          send_log(line) if match_logs_type?(line)
        end
      end
    end

    def send_log(log_message)
      if match_logs_type?(log_message)
        @log_buffer << log_message
        if @log_buffer.size >= @max_buffer_size || can_send_log?
          send_buffered_logs
          @last_interaction_time = Time.now
        else
          # @logger.info('Log buffered. Waiting for more logs or interaction interval.')
        end
      end
    end

    private
    def send_buffered_logs
      return if @log_buffer.empty?

      curr_datetime = Time.now.to_i * 1_000_000_000
      msg = "On server #{@host_name} detected error"
      payload = {
        'streams' => [
          {
            'stream' => {
              'job' => @job_name,
              'host' => @host_name
            },
            'values' => @log_buffer.map { |log| [curr_datetime.to_s, log] },
            'entries' => @log_buffer.map do |_|
              {
                'ts' => curr_datetime,
                'line' => "[WARN] " + msg
              }
            end
          }
        ]
      }

      json_payload = JSON.generate(payload)
      uri = '/loki/api/v1/push'
      @connection.post(uri, json_payload)

      @log_buffer.clear
    end

    def can_send_log?
      return true if @last_interaction_time.nil?

      elapsed_time = Time.now - @last_interaction_time
      elapsed_time >= @interaction_interval
    end

    def match_logs_type?(log_line)
      return true
      return false if log_line.nil?

      type_match = log_line.match(/(ERROR|WARN|FATAL|INFO|DEBUG)/)
      type = type_match&.to_s
      @logs_type.include?(type)
    end
  end
end
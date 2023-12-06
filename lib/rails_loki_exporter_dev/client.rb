module RailsLokiExporterDev
  LOGS_TYPE = %w(ERROR WARN FATAL INFO DEBUG).freeze

  class Client
    include RailsLokiExporterDev::Request

    attr_accessor :job_name
    attr_accessor :host_name
    attr_accessor :source_name

    def initialize(log_file_path, allowed_logs_type = LOGS_TYPE)
      @log_file_path = log_file_path
      @allowed_logs_type = allowed_logs_type
      @job_name = "job_name"
      @host_name = "host_name"
      @source_name = "source_name"
    end

    def send_all_logs
      File.open(@log_file_path, 'r') do |file|
        file.each_line do |line|
          send_log(line) if match_logs_type?(line)
        end
      end
    end

    def send_log(log_message)
      curr_datetime = Time.now.to_i * 1_000_000_000

      msg = "On server #{@host_name} detected error"

      payload = {
        'streams' => [
          {
            'stream' => {
              'source' => @source_name,
              'job' => @job_name,
              'host' => @host_name
            },
            'values' => [[curr_datetime.to_s, log_message]],
            'entries' => [
              {
                'ts' => curr_datetime,
                'line' => "[WARN] " + msg
              }
            ]
          }
        ]
      }

      json_payload = JSON.generate(payload)
      uri = '/loki/api/v1/push'

      post(uri, json_payload)
    end

    private

    def match_logs_type?(log_line)
      type = log_line.match(/(ERROR|WARN|FATAL|INFO|DEBUG)/)&.to_s

      @allowed_logs_type.include?(type)
    end
  end
end
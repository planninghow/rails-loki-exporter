module RailsLokiExporterDev
  class Client
    include RailsLokiExporterDev::Request

    def initialize(log_file_path)
      @log_file_path = log_file_path
    end

    def send_all_logs
      File.open(@log_file_path, 'r') do |file|
        file.each_line do |line|
          send_log(line)
        end
      end
    end
    def send_log(log_message)
      curr_datetime = Time.now.to_i * 1_000_000_000

      host = "somehost"
      msg = "On server #{host} detected error"

      payload = {
        "streams" => [
          {
            "stream" => {
              "source" => "Name-of-your-source",
              "job" => "name-of-your-job",
              "host" => host
            },
            "values" => [[curr_datetime.to_s, log_message]],
            "entries" => [
              {
                "ts" => curr_datetime,
                "line" => "[WARN] " + msg
              }
            ]
          }
        ]
      }

      json_payload = JSON.generate(payload)
      uri = '/loki/api/v1/push'

      # Use logger for sending logs to both default logger and Loki
      # @logger.info "Sending log to Loki: #{json_payload}"

      # Send logs to Loki using the post method
      post(uri, json_payload)
    end
  end
end


## In your Rails application code

## Assuming you are in a context where `Rails.logger` is available
#rails_logger = Rails.logger

## Create an instance of the client
#client = RailsLokiExporterDev.client(rails_logger)

## Set up log forwarding from Rails logger to Loki
#client.send_rails_logs_to_loki
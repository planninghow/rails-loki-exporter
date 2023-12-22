require 'faraday'
require 'zeitwerk'
require 'json'
require 'time'

loader = Zeitwerk:: Loader.for_gem
loader.setup

module RailsLokiExporterDev
  def self.create_logger(log_file_path, logs_type, options = {})
    intercept_logs = options.fetch(:intercept_logs, false)
    client = RailsLokiExporterDev::Client.new(log_file_path, logs_type, intercept_logs)
    logger = RailsLokiExporterDev::InterceptingLogger.new(intercept_logs: intercept_logs)
    logger.client = client
    logger
  end
end 

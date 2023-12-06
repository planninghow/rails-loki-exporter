require 'faraday'
require 'zeitwerk'
require 'json'
require 'time'

loader = Zeitwerk:: Loader.for_gem
loader.setup

module RailsLokiExporterDev
  def self.client(log_file_path, logs_type)
    RailsLokiExporterDev::Client.new(log_file_path, logs_type)
  end
end 

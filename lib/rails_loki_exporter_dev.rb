require 'faraday'
require 'zeitwerk'
require 'json'
require 'time'

loader = Zeitwerk:: Loader.for_gem
loader.setup

module RailsLokiExporterDev
    def self.client(log_folder)
      RailsLokiExporterDev::Client.new(log_folder)
    end
end 

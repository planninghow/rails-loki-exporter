require 'faraday'
require 'zeitwerk'
require 'json'
require 'time'

loader = Zeitwerk:: Loader.for_gem
loader.setup

module RailsLokiExporterDev
    def self.client
      RailsLokiExporterDev::Client.new()
    end
end 

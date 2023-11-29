require 'faraday'
require 'zeitwerk'
require 'json'

loader = Zeitwerk:: Loader.for_gem
loader.setup

module RailsLokiExporterDev
    def self.client
      RailsLokiExporterDev::Client.new()
    end
end 

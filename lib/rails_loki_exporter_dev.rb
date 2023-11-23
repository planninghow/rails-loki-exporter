require 'faraday'
require 'zeitwerk'

loader = Zeitwerk:: Loader.for_gem
loader.setup

module RailsLokiExporterDev
   
  class RailsLokiExporterDev
     def self.hi
        puts "Hello, world!"
     end
  end
end 

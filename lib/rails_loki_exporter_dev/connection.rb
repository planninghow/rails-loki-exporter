module RailsLokiExporterDev
    module Connection
        BASE_URL = 'http://host-where-loki-run:3100/'
        
        def connection
            Faraday.new do |faraday|
                faraday.adapter Faraday.default_adapter
                faraday.request :url_encoded
            end
        end

        private 

        def options
            headers = {
               'Content-type': 'application/json'
            }
        end
    end     
end 

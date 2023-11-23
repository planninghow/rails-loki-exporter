module RailsLokiExporterDev
    module Connection
        BASE_URL = 'http://localhost:3100/' 
        def connection
            Faraday.new do |faraday|
                faraday.adapter Faraday.default_adapter
                faraday.request :url_encoded
            end
        end
    end     
end 
module RailsLokiExporterDev
    module Connection
    
        BASE_URL = 'http://localhost:3100/'
        
        def connection
            Faraday.new(options) do |faraday|
                faraday.adapter Faraday.default_adapter
                faraday.request :url_encoded
            end
        end

        def post(path, body)
            response = connection.post(path) do |req|
              req.headers['Content-Type'] = 'application/json'
              req.body = JSON.generate(body)
            end
      
            # Check if the request was successful
            if response.success?
              return JSON.parse(response.body)
            else
              raise "Failed to make POST request. Response code: #{response.status}, Response body: #{response.body}"
            end
          end
      
        private 

        def options
            headers = {
                accept: 'application/json',
                'Content-Type' => 'application/json'
            }
            return {
                url: BASE_URL,
                headers: headers
            }
        end
    end     
end 

module RailsLokiExporterDev

    class Client
    include RailsLokiExporterDev::Request

        host = 'your-host'
        url = 'api/prom/push'
        curr_datetime = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        msg = 'Your message'
        payload = {
          'streams' => [
             {
                'labels' => "{source=\"Name-of-your-source\",job=\"name-of-your-job\", host=\"#{host}\"}",
                'entries' => [
                {
                  'ts' => curr_datetime,
                  'line' => "[WARN] #{msg}"
                }
              ]
            }  
          ]
        }
        json_payload = JSON.generate(payload)

        def initialize
        end 

        def someClientRequest()
            post url, {data: json_payload}
        end

        def getQuery(path) #"query", "query_range", "labels" and etc
            get "loki/api/v1/#{path}"
        end
    end     
end 
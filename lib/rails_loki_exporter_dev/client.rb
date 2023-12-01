module RailsLokiExporterDev
    class Client
    include RailsLokiExporterDev::Request
    # 'development.log'
      def initialize(log_folder) #folder with logs, find out how to define folder with logs
        @log_file_path = File.join('log',log_folder ) 
      end
    
      def send_all_logs
        File.open(@log_file_path, 'r') do |file|
          file.each_line do |line|
            send_log(line)
          end
        end
      end

        def send_log(log_message)
          curr_datetime = Time.now.to_i * 1_000_000_000

          host = "somehost"
          msg = "On server #{host} detected error"
    
          payload = {
            "streams" => [
             {
                "stream" => { 
                  "source" => "Name-of-your-source",
                  "job" => "name-of-your-job",
                  "host" => host
               },
               "values" => [["#{curr_datetime}", log_message]],
               "entries" => [
                {
                  "ts" => curr_datetime,
                  "line" => "[WARN] " + msg
                }
               ]
              }
            ]
          }

          json_payload = JSON.generate(payload)
          uri = '/loki/api/v1/push'
          post uri, json_payload
        end
       
    end     
end 
module RailsLokiExporterDev
    class MyConnection
      include Connection
  
      def self.create(base_url, user_name, password, auth_enabled, host_name, job_name)
        new(base_url, user_name, password, auth_enabled, host_name, job_name).connection
      end
    end
end
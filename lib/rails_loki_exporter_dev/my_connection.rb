module RailsLokiExporterDev
    class MyConnection
      include Connection
  
      def self.create(base_url, user_name, password, auth_enabled)
        new(base_url, user_name, password, auth_enabled).connection
      end
    end
end
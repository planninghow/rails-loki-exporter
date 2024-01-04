module RailsLokiExporterDev
    class MyConnection
      include Connection
  
      def self.create(base_url, user_name, password, auth_enabled)
        new(base_url, user_name, password, auth_enabled).connection
      end
      private
  
      def initialize(base_url, user_name, password, auth_enabled)
        uri = URI.parse(base_url)
        @base_url = uri
        @user_name = user_name
        @password = password
        @auth_enabled = auth_enabled
      end
    end
end
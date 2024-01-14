require 'faraday'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module RailsLokiExporterDev
  class << self
    def create_logger(config_file_path)
      config = load_config(config_file_path)

      connection_instance =  MyConnection.create(
        config['base_url'],
        config['user_name'],
        config['password'],
        config['auth_enabled']
      )

      client = Client.new(config)
      logger = InterceptingLogger.new(intercept_logs: config['intercept_logs'])
      if config['enable_log_subscriber'] 
        CustomLogSubscriber.client = client
      end
      logger.client = client
      client.connection = connection_instance
      logger
    end

    private

    def load_config(config_file_path)
      expanded_path = File.expand_path(config_file_path, __dir__)

      if File.exist?(expanded_path)
        config = YAML.load_file(expanded_path)
        puts config.to_json
        return config
      else
        puts "Config file not found: #{expanded_path}"
        return {}
      end
    end
  end
end

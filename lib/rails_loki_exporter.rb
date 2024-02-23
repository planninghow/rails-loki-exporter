require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.setup

module RailsLokiExporter
  class << self
    def create_logger(config_file_path)
      config = load_config(config_file_path)
      client = LokiHttpClient.new(config)
      logger = InterceptingLogger.new(intercept_logs: config['intercept_logs'])
      if config['enable_log_subscriber'] 
        CustomLogSubscriber.client = client
      end
      logger.client = client
      logger
    end

    private

    def load_config(config_file_path)
      expanded_path = File.expand_path(config_file_path, __dir__)

      if File.exist?(expanded_path)
        config_erb = ERB.new(File.read(expanded_path)).result
        config = YAML.safe_load(config_erb, aliases: true)
        return config
      else
        puts "Config file not found: #{expanded_path}"
        return {}
      end
    end
  end
end

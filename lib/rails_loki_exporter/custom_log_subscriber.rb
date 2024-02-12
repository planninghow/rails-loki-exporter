
require 'action_controller/log_subscriber'

module RailsLokiExporter
  class CustomLogSubscriber < ActiveSupport::LogSubscriber
    INTERNAL_PARAMS = %w(controller action format _method only_path)
    class << self
      attr_accessor :client
    end

    def process_action(event)
      if self.class.client
        
        payload = event.payload
        controller = payload[:controller]
        action = payload[:action]
        status = payload[:status]
        duration = event.duration.round(2)
        path = payload[:path]
        params = payload[:params].except(*INTERNAL_PARAMS)
        query_string = params.to_query

        request_url = query_string.blank? ? path : "#{path}?#{query_string}"
        log_message = "LogSubscriber - [#{controller}##{action}] URL:#{request_url}, Params: #{params}, Status: #{status}, Duration: #{duration}ms"
        self.class.client.send_log(log_message)
      end
    end
  end
end

%w(process_action start_processing).each do |evt|
    ActiveSupport::Notifications.unsubscribe "#{evt}.action_controller"
end
  
RailsLokiExporter::CustomLogSubscriber .attach_to :action_controller
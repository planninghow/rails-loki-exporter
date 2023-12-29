# frozen_string_literal: true

require 'json'
require 'net/http'

module RailsLokiExporterDev
  class InterceptingLogger < Logger
    attr_accessor :client

    def initialize(intercept_logs: false)
      @intercept_logs = intercept_logs
      @log = ""

      # Set a formatter, you can customize it as needed
      self.formatter = proc { |severity, datetime, _progname, msg|
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{msg}\n"
        @log = "[#{severity}] #{msg}"
      }
      self.level = Logger::DEBUG
    end

    def add(severity, message = nil, progname = nil, &block)
      if @intercept_logs
        client.send_log("#{message}") if client
      end
      super(severity, message, progname, &block)
    end
  end
end

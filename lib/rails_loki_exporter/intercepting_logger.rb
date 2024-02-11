# frozen_string_literal: true

require 'json'
require 'net/http'
require 'active_support/logger'

module RailsLokiExporter
  class InterceptingLogger < ActiveSupport::Logger
    attr_accessor :client

    SEVERITY_NAMES = %w(DEBUG INFO WARN ERROR FATAL ANY).freeze

    def initialize(intercept_logs: false)
      @intercept_logs = intercept_logs
      @log = ""
      super(STDOUT)
      self.level = Logger::DEBUG
    end

    def add(severity, message = nil, progname = nil, &block)
      severity_name = severity_name(severity)
      log_message = message
      if log_message.nil?
        if block_given?
          log_message = yield
        else
          log_message = progname
          progname = @progname
        end
      end

      if @intercept_logs && !log_message.nil?
          formatted_message = format_message(severity_name, Time.now, progname, log_message)
          client.send_log(formatted_message) if client
      end

      super(severity, message, progname, &block)
    end

    def broadcast_to(console)
      client.send_log(@log) if client
    end

    private

    def format_message(severity, datetime, progname, msg)
          puts "severity: #{severity}"
          puts "datetime: #{datetime}"
          puts "progname: #{progname}"
          puts "msg: #{msg}"
      "#{severity} #{progname}: #{msg}\n"
    end

    def severity_name(severity)
      SEVERITY_NAMES[severity] || "UNKNOWN"
    end
  end
end
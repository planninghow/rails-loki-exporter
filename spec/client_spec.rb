# spec/client_spec.rb
require 'spec_helper'
require 'rspec'
require 'rails_loki_exporter_dev'

RSpec.describe RailsLokiExporterDev::Client do
  let(:log_file_path) { 'log/development.log' }
  let(:client) { RailsLokiExporterDev.client(log_file_path) }

  describe '#send_all_logs' do
    it 'sends all logs to Loki' do
      allow(File).to receive(:open).with(log_file_path, 'r').and_yield(StringIO.new("log line 1"))

      expect(client).to receive(:send_log).with("log line 1")
      client.send_all_logs
    end
  end

  describe '#send_log' do
    it 'sends a log entry to Loki' do
      allow(client).to receive(:post)
      allow(Time).to receive(:now).and_return(Time.new(2023, 1, 1)) # Adjust as needed

      expect(client).to receive(:post).with('/loki/api/v1/push', String)

      client.send_log('Log message')

      # Additional assertions based on your requirements
    end
  end
end
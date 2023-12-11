# spec/client_spec.rb
require 'spec_helper'
require 'rspec'
require 'rails_loki_exporter_dev'

RSpec.describe RailsLokiExporterDev::Client do
  let(:log_file_path) { 'path/to/your/log/file.log' }
  let(:allowed_logs_type) { %w(ERROR WARN FATAL INFO DEBUG) }
  let(:client) { described_class.new(log_file_path, allowed_logs_type) }

  describe '#initialize' do
    it 'initializes with default values' do
      expect(client.job_name).to eq 'job name'
      expect(client.host_name).to eq 'host name'
      expect(client.source_name).to eq 'source name'
    end
  end

  describe '#match_logs_type?' do
    it 'returns true for allowed log type' do
      log_line = '[INFO] This is an info message'
      expect(client.match_logs_type?(log_line)).to be_truthy
    end

    it 'returns false for disallowed log type' do
      log_line = '[TRACE] This is a trace message'
      expect(client.match_logs_type?(log_line)).to be_falsey
    end
  end

  describe '#send_log' do
    it 'sends a log message' do
      allow(client).to receive(:post)

      log_message = 'Sample log message'
      client.send_log(log_message)

      expect(client.host_name).to eq 'host name'
      expect(client.job_name).to eq 'job name'
      expect(client.source_name).to eq 'source name'
    end
  end

  describe '#send_all_logs' do
    it 'sends all logs matching allowed types' do
      allow(File).to receive(:open).and_yield("Line 1\n[ERROR] Line 2\nLine 3\n[DEBUG] Line 4")
      allow(client).to receive(:send_log)
      client.send_all_logs

      expect(client).to have_received(:send_log).with("[ERROR] Line 2\n")
      expect(client).to have_received(:send_log).with("[DEBUG] Line 4")
    end
  end
end


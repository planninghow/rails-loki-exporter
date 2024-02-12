# spec/client_spec.rb
require 'spec_helper'
require 'rspec'
require 'rails_loki_exporter'

RSpec.describe RubyForGrafanaLoki::Client do
  let(:log_file_path) { 'development.log' }
  let(:allowed_logs_type) { %w(ERROR WARN FATAL INFO DEBUG) }
  let(:client) { described_class.new(log_file_path, allowed_logs_type) }

  describe '#initialize' do
    it 'sets default values' do
      expect(client.job_name).to eq 'job name'
      expect(client.host_name).to eq 'host name'
      expect(client.source_name).to eq 'source name'
      expect(client.interaction_interval).to eq 1
      expect(client.max_buffer_size).to eq 100
    end
  end

  describe '#send_all_logs' do
    it 'sends logs to the server' do
      allow(client).to receive(:send_log)
      allow(File).to receive(:open).with(log_file_path, 'r').and_yield(StringIO.new("ERROR Test log"))

      client.send_all_logs

      expect(client).to have_received(:send_log).with('ERROR Test log').once
    end
  end

  describe '#send_log' do
    it 'buffers and sends logs when needed' do
      allow(client).to receive(:post)
      allow(client).to receive(:can_send_log?).and_return(false, true)

      client.send_log('ERROR Test log')
      client.send_log('INFO Another log')

      expect(client).to have_received(:post).once
    end
  end

  describe '#can_send_log?' do
    it 'returns true initially and after the interaction interval' do
      expect(client.send(:can_send_log?)).to be true

      client.instance_variable_set(:@last_interaction_time, Time.now - 2)
      expect(client.send(:can_send_log?)).to be true

      client.instance_variable_set(:@last_interaction_time, Time.now)
      expect(client.send(:can_send_log?)).to be false
    end
  end

  describe '#match_logs_type?' do
    it 'returns true for matching log types' do
      expect(client.send(:match_logs_type?, 'ERROR Test log')).to be true
      expect(client.send(:match_logs_type?, 'TRACE Another log')).to be false
    end
  end
end

RSpec.describe RailsLokiExporter::Client do
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


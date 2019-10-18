# frozen_string_literal: true

module ActiveadminAsyncExporter
  class Configuration
    attr_reader :report_uploader

    attr_accessor :aws_s3_configuration
    attr_accessor :aws_s3_upload

    def initialize
      @aws_s3_upload = false
    end

    def report_uploader
      @report_uploader ||= ActiveadminAsyncExporter::Uploaders::AmazonS3
    end

    def upload_reports?
      @aws_s3_upload
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end

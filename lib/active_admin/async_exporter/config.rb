# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    class << self
      def configure
        yield config
      end

      def config
        @config ||= Config.new
      end
    end

    class Config
      attr_accessor :service, :aws_bucket_name, :aws_bucket_folder_path, :disk_folder_path

      def initialize
        @aws_bucket_name = nil
        @aws_bucket_folder_path = nil
        @disk_folder_path = Rails.root.join('tmp/activeadmin-async_exporter')
      end
    end
  end
end

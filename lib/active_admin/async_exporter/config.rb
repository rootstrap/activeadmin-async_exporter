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
      attr_accessor :aws_bucket_name, :aws_bucket_folder_path

      def initialize
        @aws_bucket_name = nil
        @aws_bucket_folder_path = nil
      end
    end
  end
end

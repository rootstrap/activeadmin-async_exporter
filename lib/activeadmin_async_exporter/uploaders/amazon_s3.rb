# frozen_string_literal: true

require 'aws-sdk-s3'

module ActiveadminAsyncExporter
  module Uploaders
    class AmazonS3
      FILES_PREFIX = 'csv_reports'

      def self.upload(file_path, options = {})
        new(file_path, options).upload
      end

      def initialize(file_path, options)
        @file_path = file_path
        @options = options

        configure_client
      end

      def upload
        begin
          resource = Aws::S3::Resource.new

          target_file = resource.bucket(bucket_name).object(remote_file_name)

          target_file.upload @file_path
        rescue Aws::S3::Errors::ServiceError
          # TODO @horacio: Things have gone south. Retry?
        end
      end

      private

      def aws_s3_configuration
        ActiveadminAsyncExporter.configuration.aws_s3_configuration
      end

      def configure_client
        Aws.config.update(
          access_key_id: aws_s3_configuration.access_key_id,
          secret_access_key: aws_s3_configuration.secret_access_key,
          region: aws_s3_configuration.region
        )
      end

      def bucket_name
        aws_s3_configuration.bucket_name
      end

      def file_name
        File.basename @file_path
      end

      def remote_file_name
        File.join FILES_PREFIX, file_name
      end
    end
  end
end

# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    module Services
      class AwsS3Service
        attr_accessor :file, :s3, :bucket, :object

        def initialize(file)
          @file = file
          @s3 = Aws::S3::Resource.new
          @bucket = s3.bucket(ActiveAdmin::AsyncExporter.config.aws_bucket_name)
        end

        def store
          @object = bucket.object(filename)
          object.upload_file(Pathname.new(file[:path]), { acl: 'public-read' })
          self
        end

        def url
          object.public_url.to_s
        end

        def delete
          bucket.delete_objects({ delete: { objects: [{ key: filename }] } })
        end

        private

        def filename
          @filename ||= "#{bucket_folder}#{file[:name]}"
        end

        def bucket_folder
          path = ActiveAdmin::AsyncExporter.config.aws_bucket_folder_path
          return '' if path.blank?

          "#{path}/"
        end
      end
    end
  end
end

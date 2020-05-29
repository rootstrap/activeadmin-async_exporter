# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    module Services
      class StorageService
        private_class_method :new

        def self.call(*args)
          case ActiveAdmin::AsyncExporter.config.service
          when :amazon
            Services::AwsS3Service.new(*args)
          end
        end
      end
    end
  end
end

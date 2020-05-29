# frozen_string_literal: true

module ActiveAdmin
  module AsyncExporter
    module Services
      class DiskService
        attr_accessor :file, :folder

        def initialize(file)
          @file = file
          @folder = ActiveAdmin::AsyncExporter.config.disk_folder_path
        end

        def store
          make_dir
          @object = IO.copy_stream(file[:path], filename)
          self
        end

        def url
          filename
        end

        def delete
          File.delete(filename)
        end

        private

        def make_dir
          FileUtils.mkdir_p(folder)
        end

        def filename
          @filename ||= "#{folder}/#{file[:name]}"
        end
      end
    end
  end
end

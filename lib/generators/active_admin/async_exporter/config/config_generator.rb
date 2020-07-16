module ActiveAdmin
  module AsyncExporter
    module Generators
      class ConfigGenerator < Rails::Generators::Base
        source_root File.join(__dir__, 'templates')

        def copy_config_file
          template 'async_exporter_config.rb', 'config/initializers/activeadmin-async_exporter.rb'
        end
      end
    end
  end
end

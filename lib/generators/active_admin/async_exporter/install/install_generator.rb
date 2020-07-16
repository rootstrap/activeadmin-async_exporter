# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveAdmin
  module AsyncExporter
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include ActiveRecord::Generators::Migration

        argument :user_class, type: :string, default: 'User'

        source_root File.join(__dir__, 'templates')

        def configure
          create_admin_reports_migration
          create_admin_reports_model
          create_active_admin_view
        end

        private

        def create_admin_reports_migration
          migration_template(
            'migration.rb',
            'db/migrate/add_admin_reports.rb',
            user_table_name: user_table_name
          )
        end

        def create_admin_reports_model
          template(
            'admin_report.rb',
            'app/models/admin_report.rb',
            user_class: user_class
          )
        end

        def create_active_admin_view
          template(
            'admin_reports.rb',
            'app/admin/admin_reports.rb'
          )
        end

        def user_class_name
          user_class.underscore.singularize
        end

        def user_table_name
          user_class_name.pluralize
        end
      end
    end
  end
end

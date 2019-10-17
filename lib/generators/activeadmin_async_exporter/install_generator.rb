# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveadminAsyncExporter
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    argument :user_class, type: :string, default: 'User'

    source_root File.join(__dir__, 'templates')

    def configure
      create_admin_reports_migration
      create_admin_reports_model
    end

    private

    def create_admin_reports_migration
      migration_template(
        'migration.rb',
        'db/migrate/add_admin_reports.rb',
        user_class_name: user_class_name
      )
    end

    def create_admin_reports_model
      template(
        'admin_report.rb',
        'app/admin/models/admin_report.rb',
        user_class_name: user_class_name
      )
    end

    def user_class_name
      user_class.underscore.singularize
    end
  end
end

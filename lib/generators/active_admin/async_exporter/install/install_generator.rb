# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveAdmin::AsyncExporter
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
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
          user_table_name: user_table_name,
          migration_version: migration_version,
          admin_report_users_foreign_key: admin_report_users_foreign_key
        )
      end
  
      def create_admin_reports_model
        template(
          'admin_report.rb',
          'app/models/admin_report.rb',
          user_class: user_class,
          admin_report_status_enum: admin_report_status_enum
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
  
      def admin_report_status_enum
        if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('4.1.8')
          'enum_accessor :status, [:pending, :ready, :error]'
        else
          'enum status: { pending: 0, ready: 1, error: 2 }'
        end
      end
  
      def admin_report_users_foreign_key
        if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('4.2.1')
          admin_report_users_foreign_key_sql
        else
          "add_foreign_key :admin_user_reports, :#{user_table_name}, column: :author_id, primary_key: 'id'"
        end
      end
  
      def admin_report_users_foreign_key_sql
        <<~FOREIGN_KEY
          # Add #{user_table_name} foreign key
              execute <<~SQL
                ALTER TABLE admin_user_reports
                ADD CONSTRAINT fk_admin_user_reports_#{user_table_name}
                FOREIGN KEY (author_id)
                REFERENCES #{user_table_name}(id)
              SQL
        FOREIGN_KEY
      end
  
      def migration_version
        if rails5_and_up?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
  
      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end
    end
  end
end

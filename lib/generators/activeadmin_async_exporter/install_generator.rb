# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveadminAsyncExporter
  class InstallGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    source_root File.join(__dir__, 'templates')

    def create_admin_reports_migration
      migration_template(
        'migration.rb',
        'db/migrate/add_admin_reports.rb',
        migration_version: migration_version
      )
    end

    private

    def migration_version
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end
  end
end

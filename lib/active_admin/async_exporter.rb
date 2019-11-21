# frozen_string_literal: true

require 'active_admin/async_exporter/version'
require 'sidekiq/web'
require 'active_admin'

require 'active_admin/async_exporter/reports/dsl'
require 'active_admin/async_exporter/reports/worker'

module ActiveAdmin
  module AsyncExporter
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        ActiveAdmin::ResourceDSL.include ActiveAdmin::AsyncExporter::Reports::DSL
      end
    end
  end
end

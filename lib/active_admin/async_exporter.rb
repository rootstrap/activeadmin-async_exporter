# frozen_string_literal: true

require 'active_admin'

require 'active_admin/async_exporter/version'
require 'active_admin/async_exporter/config'
require 'active_admin/async_exporter/reports/dsl'
require 'active_admin/async_exporter/reports/worker'
require 'active_admin/async_exporter/services/aws_s3_service'

module ActiveAdmin
  module AsyncExporter
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        ActiveAdmin::ResourceDSL.include ActiveAdmin::AsyncExporter::Reports::DSL
      end
    end
  end
end

# frozen_string_literal: true

require 'activeadmin_async_exporter'
require 'activeadmin_async_exporter/models/admin_report'
require 'activeadmin_async_exporter/reports/dsl'
require 'activeadmin_async_exporter/reports/worker'
require 'activeadmin_async_exporter/uploaders/amazon_s3'

class Railtie < ::Rails::Railtie
  config.after_initialize do
    ActiveAdmin::ResourceDSL.include ActiveadminAsyncExporter::Reports::DSL
  end
end

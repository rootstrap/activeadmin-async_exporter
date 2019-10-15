# frozen_string_literal: true

require 'activeadmin_async_exporter'
require 'activeadmin_async_exporter/reports/dsl'
require 'activeadmin_async_exporter/reports/worker'

class Railtie < ::Rails::Railtie
  config.after_initialize do
    ActiveAdmin::ResourceDSL.include ActiveadminAsyncExporter::Reports::DSL
  end
end

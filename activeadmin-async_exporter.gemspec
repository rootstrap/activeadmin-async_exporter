# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'active_admin/async_exporter/version'

Gem::Specification.new do |s|
  s.name        = 'activeadmin-async_exporter'
  s.version     = ActiveAdmin::AsyncExporter::VERSION
  s.date        = '2019-10-09'
  s.summary     = 'Async exporter for Active Admin using Sidekiq'
  s.description = s.summary
  s.authors     = ['Franco Pariani', 'Horacio Bertorello']
  s.email       = 'franco@rootstrap.com'
  s.homepage    = 'https://rubygems.org/gems/activeadmin-async_exporter'
  s.metadata    = { 'source_code_uri' => 'https://github.com/rootstrap/activeadmin-async_exporter' }
  s.license     = 'MIT'
  s.files       = Dir['lib/**/*.{rb,tt}']

  # Dependencies
  s.add_runtime_dependency 'activeadmin', '>= 1.0.0.pre1'

  s.add_dependency 'rails', '>= 1.0.0'
  s.add_dependency 'sidekiq', '>= 1.0.0'

  s.add_development_dependency 'rubocop', '~> 0.75.1'
end

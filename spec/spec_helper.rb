# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'dummy/config/environment.rb'
require 'pry'
require 'active_admin'
require 'timecop'

require 'simplecov'
SimpleCov.start

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

require 'tmpdir'
ActiveStorage::Blob.service =
  ActiveStorage::Service::DiskService.new(root: Dir.mktmpdir('active_storage_tests'))

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

load 'dummy/db/schema.rb'

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

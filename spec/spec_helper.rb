# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'dummy/config/environment.rb'
require 'active_admin'
require 'support/time_helpers.rb'

require 'simplecov'
SimpleCov.start

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

require 'tmpdir'

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

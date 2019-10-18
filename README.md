# ActiveadminAsyncExporter

Async CSV exporter for Active Admin using Sidekiq.

## Installation

All you have to do is add the gem to your project like this:

```bash
$ gem 'activeadmin_async_exporter'
```

On your Rails project, add this line to your Gemfile:

```ruby
gem 'activeadmin_async_exporter'
```

## Installation

```bash
# If you want to use an existing user class, provide it as an argument
$ rails generate activeadmin_async_exporter:install SuperAdminUser
# Otherwise, you can call it without arguments, and we'll assume `User`
$ rails generate activeadmin_async_exporter:install
```

You'll need to configure your AWS credentials if you're going to want your CSV
reports uploaded to S3:

```ruby
# config/initializers/active_record_async_reports.rb

ActiveadminAsyncExporter.configure do |config|
  # Configure with your AWS S3 credentials to upload your CSV reports.
  config.aws_s3_upload = true
  config.aws_s3_configuration = {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
end
```

Finally:

```bash
$ rails db:migrate
```

## Contributing

Bug reports (please use Issues) and pull requests are welcome on GitHub at https://github.com/rootstrap/activeadmin_async_exporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

**ActiveadminAsyncExporter** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/activeadmin_async_exporter/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)

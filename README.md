# ActiveAdmin::AsyncExporter

Async exporter for Active Admin using ActiveJob.

## Installation
All you have to do is add the gem to your project like this:
```bash
$ gem 'activeadmin-async_exporter'
```

## Usage
In order to use the gem, simply go to the admin file of the model you want to generate CSV reports of and add the `csv_async` helper.
For example, let's use `User` as our model
```ruby
# User
## email
## first_name
## last_name
## created_at

ActiveAdmin.register User do
  csv_async do
    csv_colmun(:email)
    csv_column(:created_at)
  end
end
```
If you want to change the column header name, you can do so by adding another parameter, for example:
```ruby
ActiveAdmin.register User do
  csv_async do
    csv_colmun(:email)
    csv_column(:date_joined, :created_at)
  end
end
```
this will let the gem know that the column header name has to be `date_joined` and use the `created_at` value for it.


Now, let's say we need to add some logic to the data added to the CSV, for example, instead of having `first_name` and `last_name` as separate columns, we can have just one `full_name` column, to achieve this, we encourage you to use decorators. Let's see an example using Draper:
```ruby
class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}"
  end
end

ActiveAdmin.register User do
  decorate_with UserDecorator

  csv_async do
    csv_colmun(:email)
    csv_column(:full_name)
    csv_column(:date_joined, :created_at)
  end
end
```


## Contributing
Bug reports (please use Issues) and pull requests are welcome on GitHub at https://github.com/rootstrap/activeadmin-async_exporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits
**ActiveAdmin::AsyncExporter** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/activeadmin-async_exporter/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)

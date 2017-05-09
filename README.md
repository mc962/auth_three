# AuthThree
This is a small gem that will generate the necessary files and configuration for
a simple, effective authentication pattern.

## Usage
After installation, run `rails g auth_three:install`, and the generator will
separate the appropriate files and run the necessary database migrations.

There is also a setting for controller namespacing, which is intended to make namespaced api
controllers and routes. Add a `--namespace=api` argument to your generation command to generate
namespaced controllers and routes. Note, this option is intended to be used to make namespaced
api controllers, and so will output controller files and routes that by default will respond with JSON.
All output may be modified later.

This pattern requires BCrypt for securing passwords. Be sure to have it in your Gemfile and run `bundle install` if necessary.

A database is required to use this pattern and run the generator. Be sure to run bundle exec rake db:create
if one does not yet exist.


*It is recommended to run this generator at the start of a project to avoid conflicts with other content already present.*

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'auth_three'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install auth_three
```

## Contributing
Contributions are always welcome.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

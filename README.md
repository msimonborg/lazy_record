# LazyRecord

LazyRecord writes a bunch of boilerplate code for your POROs, similarly to what you'd expect ActiveRecord to do for your database-backed objects. This project is an attempt to understand and explore dynamic programming techniques in Ruby, and demystify some of the Rails magic. Maybe someone will find it useful.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lazy_record'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_record

## Usage

All objects that inherit from `LazyRecord::Base` get block syntax added to their `#initialize` method.

```ruby
class Thing < LazyRecord::Base
end

thing = Thing.new do |t|
  # do stuff
end
```

Here are some of the class method macros you get when your class inherits from

```ruby
lr_attr_accessor
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lazy_record.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

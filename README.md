# LazyRecord
[![Gem Version](https://badge.fury.io/rb/lazy_record.svg)](https://badge.fury.io/rb/lazy_record)
[![Code Climate](https://codeclimate.com/github/msimonborg/lazy_record/badges/gpa.svg)](https://codeclimate.com/github/msimonborg/lazy_record)
[![Build Status](https://travis-ci.org/msimonborg/lazy_record.svg?branch=master)](https://travis-ci.org/msimonborg/lazy_record)
[![Coverage Status](https://coveralls.io/repos/github/msimonborg/lazy_record/badge.svg?branch=master)](https://coveralls.io/github/msimonborg/lazy_record?branch=master)

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

thing = Thing.new { |t| puts t.class.superclass }
# LazyRecord::Base
# => #<Thing>
```

Alternatively, if you want to inherit from another class, you can mix in the `LazyRecord::BaseModule` and get all the same results.

```ruby
class Thing
  include LazyRecord::BaseModule
end

thing = Thing.new { |t| puts t.class.superclass }
# Object
# => #<Thing>
```
Every LazyRecord object is assigned an auto-incrementing ID after initialization. IDs reset when the program is terminated.

Use `attr_accessor` like you would use normally, and you'll get hash syntax in your `#intialize` method for attribute setting. The attributes will also be visible when the object is returned or `inspected`. Attributes defined with `attr_reader` will also be visible, but `attr_writers`, custom getters and writers, and other methods will not.

```ruby
class Thing < LazyRecord::Base
  attr_accessor :stuff, :junk
  attr_reader :hmm

  def something
    @something ||= 'something'
  end
end

thing = Thing.new stuff: 'stuff' do |t|
  t.junk = 'junk'
end
# => #<Thing stuff: "stuff", junk: "junk", hmm: nil>
thing.something
# => "something"
```
If you want to define private or protected `attr_accessor`s or `attr_reader`s, they will not be visible when inspecting the object, and you should do so like the following example.
```ruby
class Thing < LazyRecord::Base
  attr_accessor :stuff, :junk
  private :junk, :junk= # passing the setter and getter method names as arguments to Module.private/Module.protected will work

  private_attr_accessor :hmm # this also works
  protected_attr_accessor :huh # this works too

  private
  attr_accessor :what # declaring the methods after calling the private method will not work, and the methods will be public and visible.
                      # this is a bug due to the custom implementation of .attr_*, and if anyone can find a fix please submit it!
                      # otherwise, the other two forms work just fine.
                      # and really, who wants to declare private attr_accessors this way anyway :-P ?
end
```
Earlier implementations used a custom `lr_attr_accessor` method, however this has been deprecated in favor of overriding `attr_*` so the methods will be parsed by RDoc.

See @dbrady's `scoped_attr_accessor` gem for more info on the `scoped_attr_*` methods.

Validate presence of attributes with `lr_validates` like you would with ActiveRecord. Failed validations will return false and the ID will not be incremented. More validation options coming in the future.

```ruby
class Thing < LazyRecord::Base
  attr_accessor :stuff, :junk
  lr_validates :stuff, presence: true
end

thing = Thing.new junk: 'junk'
ArgumentError
stuff must be given
#<Thing stuff: nil, junk: "junk">
# => false
```
Use `lr_has_many` to set up associated collections of another class. `lr_belongs_to` will be added in a future update.

```ruby
class Whatever < LazyRecord::Base
end

class Thing < LazyRecord::Base
  attr_accessor :stuff, :junk
  lr_validates :stuff, presence: true
  lr_has_many :whatevers
end

whatever = Whatever.new
# => #<Whatever>

thing = Thing.new do |t|
  t.stuff = 'stuff'
  t.whatevers << whatever
end
# => #<Thing stuff: "stuff", junk: nil>

thing.whatevers
# => #<WhateverRelation [#<Whatever>]>
```

Use `lr_scope` and `#where` to create class scope methods and query objects.

```ruby
class Whatever < LazyRecord::Base
  attr_accessor :party_value, :sleepy_value
  lr_scope :big_party, -> { where { |w| w.party_value > 10 } }
  lr_scope :low_sleepy, -> { where { |w| w.sleepy_value < 10 } }
end

class Thing < LazyRecord::Base
  lr_attr_accessor :stuff, :junk
  lr_validates :stuff, presence: true
  lr_has_many :whatevers
end

Whatever.new party_value: 12, sleepy_value: 12
Whatever.new party_value: 13, sleepy_value: 3
Whatever.new party_value: 4, sleepy_value: 11
Whatever.new party_value: 3, sleepy_value: 5
thing = Thing.new do |t|
  t.stuff = 'stuff'
  t.whatevers = Whatever.all
end
# => #<Thing stuff: "stuff", junk: nil>

thing.whatevers.big_party
# => #<WhateverRelation [#<Whatever party_value: 12, sleepy_value: 12>, #<Whatever party_value: 13, sleepy_value: 3>]>

thing.whatevers.low_sleepy
# => #<WhateverRelation [#<Whatever party_value: 13, sleepy_value: 3>, #<Whatever party_value: 3, sleepy_value: 5>]>

thing.whatevers.big_party.low_sleepy
# => #<WhateverRelation [#<Whatever party_value: 13, sleepy_value: 3>]>

Whatever.low_sleepy
# => #<WhateverRelation [#<Whatever party_value: 13, sleepy_value: 3>, #<Whatever id: 4, party_value: 3, sleepy_value: 5>]>

Whatever.where party_value: 12
# => #<WhateverRelation [#<Whatever party_value: 12, sleepy_value: 12>
```
You can also use hash syntax and block syntax with `.where`. Block syntax will yield each object in the collection to the block for evaluation.
```ruby
Whatever.where { |w| w.sleepy_value > 5 }
# => #<WhateverRelation [#<Whatever party_value: 12, sleepy_value: 12>, #<Whatever id: 3, party_value: 4, sleepy_value: 11>]>
Whatever.where { |w| w.sleepy_value == w.party_value }
# => #<WhateverRelation [#<Whatever party_value: 12, sleepy_value: 12>]>
```
When using hash syntax the value can be an object, an expression, or a Proc.
```ruby
Whatever.where party_value: 12
# => #<WhateverRelation [#<Whatever party_value: 12, sleepy_value: 12>]>
Whatever.where party_value: 7 + 6, sleepy_value: 3
# => #<WhateverRelation [#<Whatever party_value: 13, sleepy_value: 3>]>
num = 6
Whatever.where party_value: -> { num * 2 }
# => #<WhateverRelation [#<Whatever party_value: 12, sleepy_value: 12>]>
```
Use `lr_method` for an alternative API for defining short instance methods using lambda syntax. The first argument passed to the block must be the receiver of the method, or `self` in the method scope.

```ruby
class Whatever < LazyRecord::Base
  attr_accessor :party_value, :sleepy_value, :right
  lr_scope :big_party, -> { where { |w| w.party_value > 10 } }
  lr_scope :low_sleepy, -> { where { |w| w.sleepy_value < 10 } }
end

class Thing < LazyRecord::Base
  attr_accessor :stuff, :junk
  lr_validates :stuff, presence: true
  lr_has_many :whatevers
  lr_method :speak, -> (_x, string) { puts string }
  lr_method :what_am_i, ->(x) { "I'm a #{x.class}" }
end

thing = Thing.new stuff: 'stuff'
thing.speak "I'm a thing"
# I'm a thing
# => nil
thing.what_am_i
# => "I'm a Thing"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment. There is an `example` directory with some LazyRecord classes defined.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/msimonborg/lazy_record.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

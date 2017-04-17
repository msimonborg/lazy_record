# frozen_string_literal: true
# Example class
class Person < LazyRecord::Base
  attr_accessor :name, :age, :haircut
  lr_has_many :dogs, :cats
  lr_has_one :friend
  lr_accepts_nested_attributes_for :dogs, :cats

  lr_scope :new_with_dog, lambda { |opts = {}|
    opts[:dog] = {} unless opts[:dog]
    new(opts) { |p| p.adopt_a_dog(opts[:dog]) }
  }
  lr_scope :young, -> { where('age < 30') }
  lr_scope :old, -> { where { |x| x.age > 30 } }
  lr_scope :short_hair, -> { where(haircut: 'short') }

  lr_method :speak, ->(string) { puts string }
  lr_method :add_dog, :name, 'dogs << Dog.new(name: name)'
  lr_method :introduce_yourself, 'puts "Hello, my name is #{name}"'

  lr_validates :name, :age, presence: true

  def self.new(opts = {})
    puts 'hi'
    super
  end

  def self.make_people(*args)
    opts = args.extract_options!

    people = args.map { |arg| Person.new(name: arg) { |p| p.age = 30 } }

    puts "There are #{people.size} people!" if opts[:count] == true

    if opts[:dog]
      people.each do |prsn|
        prsn.adopt_a_dog(opts[:dog]) { |d| d.name = "#{prsn.name}'s best friend" }
      end
    end

    people.tap { |person| yield person } if block_given?
  end

  def times(num)
    if block_given?
      i = 0
      while i < num
        yield
        i += 1
      end
      i
    else
      self
    end
  end

  def adopt_a_dog(opts = {})
    dog = Dog.new(opts)
    yield dog if block_given?
    dogs << dog
    dog
  end

  JOE = new_with_dog(
    name: 'Joe',
    age: 35,
    haircut: 'short',
    dog: {
      cute: true,
      name: 'Frank',
      breed: 'Schnauzer',
      weight: 45,
      friend: true,
      years_known: 6
    }
  )
end

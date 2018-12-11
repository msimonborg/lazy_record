# frozen_string_literal: true

# Example class
class Person < LazyRecord::Base
  attr_accessor :name, :age, :haircut
  lazy_has_many :dogs
  lazy_has_many :kitties, class_name: 'Cat'
  lazy_has_one :friend
  lazy_accepts_nested_attributes_for :dogs, :kitties

  lazy_scope :new_with_dog, lambda { |opts = {}|
    dog = opts.fetch(:dog) { {} }
    new(opts) { |p| p.adopt_a_dog(dog) }
  }
  lazy_scope :young, -> { where { |obj| obj.age < 30 } }
  lazy_scope :old, -> { where { |obj| obj.age > 30 } }
  lazy_scope :short_hair, -> { where(haircut: 'short') }

  lazy_method :speak, ->(phrase) { "#{name}: '#{phrase}'" }
  lazy_method :add_dog, ->(name) { dogs << Dog.new(name: name) }
  lazy_method :introduction, -> { puts "Hello, my name is #{name}" }
  lazy_method :say_hi, -> { "Hi from #{self}" }

  lazy_validates :name, :age, presence: true

  def self.make_people(*args)
    opts = args.extract_options!

    people = args.map { |arg| Person.new(name: arg) { |p| p.age = 30 } }

    puts "There are #{people.size} people!" if opts[:count] == true

    if opts[:dog]
      people.each do |pn|
        pn.adopt_a_dog(opts[:dog]) { |d| d.name = "#{pn.name}'s best friend" }
      end
    end

    people.tap { |person| yield person } if block_given?
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

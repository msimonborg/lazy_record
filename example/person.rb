# frozen_string_literal: true
# Example class
class Person < LazyRecord::Base
  lr_attr_accessor :name, :age, :haircut
  lr_has_many :dogs, :cats
  lr_accepts_nested_attributes_for :dogs, :cats

  can_multiply

  lr_scope :new_with_dog, ->(opts = {}) {
    opts[:dog] = {} unless opts[:dog]
    self.new(opts) { |p| p.adopt_a_dog(opts[:dog]) }
  }
  lr_scope :young, -> { where('age < 30') }
  lr_scope :short_hair, -> { where('haircut == "short"') }

  lr_method :speak, -> (string) { puts string }
  lr_method :add_dog, :name, 'dogs << Dog.new(name: name)'
  lr_method :introduce_yourself, 'puts "Hello, my name is #{name}"'

  lr_validates :name, :age, presence: true

  def self.make_people(*args, &block)
    opts = args.extract_options!

    people = args.map do |arg|
      Person.new { |p| p.name = arg }
    end

    if opts[:count] == true
      puts "There are #{people.size} people!"
    end

    if opts[:dog]
      people.each do |person|
        person.adopt_a_dog(opts[:dog]) do |d|
          d.name = "#{person.name}'s best friend"
        end
      end
    end

    people.each { |person| block.call(person) } if block

    people
  end

  def times(num, &block)
    if block
      i = 0
      while i < num
        block.call
        i += 1
      end
      i
    else
      self
    end
  end

  def adopt_a_dog(opts = {}, &block)
    dog = Dog.new(opts)
    block.call(dog) if block
    self.dogs << dog
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
  ).freeze
end

# frozen_string_literal: true

# Example class
class Dog < LazyRecord::Base
  attr_accessor :name, :breed, :weight
  lazy_has_many :friends

  def initialize(opts = {})
    super
    friends << Friend.new(opts) if opts[:friend] == true
    self.name = name + 'y' if opts[:cute] == true
  end
end

# frozen_string_literal: true
# Example class
class Friend < LazyRecord::Base
  attr_accessor :years_known, :age

  private_attr_accessor :name
end

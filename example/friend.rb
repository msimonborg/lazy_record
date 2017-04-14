# frozen_string_literal: true
# Example class
class Friend < LazyRecord::Base
  attr_accessor :years_known, :age, :who, :what

  private_attr_accessor :name

  protected_attr_accessor :hmm

  private :who, :who=
  private :what, :what=
end

# frozen_string_literal: true
module LazyRecord
  # Inherit from LazyRecord::Base to achieve lazier development.
  #
  # LazyRecord gives you some ActiveRecord-style conveniences for your in-memory
  # POROs. These include more powerful attr_accessors, object caching, instance
  # method generating macros, scope methods and scope chaining, associations
  # with other objects, and validations. This is a WIP still in development.
  class Base
    extend Scopes
    extend Attributes
    extend Associations
    extend Callbacks
    extend Validations
    extend Methods
    extend DynamicModules

    class << self
      attr_reader :all
    end

    attr_writer :id

    def self.count
      @all.count
    end

    def self.first
      @all.first
    end

    def self.last
      @all.last
    end

    def self.where(condition)
      @all.where(condition)
    end

    def initialize(_opts = {})
      yield self if block_given?
    end

    def instance_attrs_to_s
      []
    end

    def instance_attr_accessors
      []
    end

    def id
      @id.freeze
    end

    private :id=

    def inspect
      "#<#{self.class} id: #{id ? id : 'nil'}"\
      "#{instance_attrs_to_s.unshift('').join(', ')}>"
    end
  end
end

# frozen_string_literal: true

module LazyRecord
  # This module gives the Base class its functionality, and can be included
  # in any class as an alternative to inheriting from LazyRecord::Base
  module BaseModule
    # Extend these modules when BaseModule is included
    def self.included(base)
      base.extend ScopedAttrAccessor
      base.extend ClassMethods
      base.extend Scopes
      base.extend Attributes
      base.extend Collections
      base.extend Associations
      base.extend Callbacks
      base.extend Validations
      base.extend Methods
      base.extend DynamicModules
    end

    # Use options hash to set attributes, and/or operate on object in a block.
    # Checks each options key for a matching attribute setter method.
    def initialize(opts = {})
      opts.each do |key, val|
        send("#{key}=", val) if respond_to?("#{key}=")
      end
      yield self if block_given?
    end

    def inspect
      format('#<%s%s>',
             self.class,
             displayable_attributes.join(', '))
    end

    def associations
      []
    end

    def collections
      []
    end

    def ==(other)
      compare(other, :==)
    end

    def ===(other)
      compare(other, :===)
    end

    def compare(other, operator)
      conditions = set_equality_conditions
      return false if !other.is_a?(self.class) || conditions.empty?
      conditions.all? { |attr| send(attr).send(operator, other.send(attr)) }
    end

    def hash
      conditions = set_equality_conditions
      hash = {}
      conditions.each { |attr| hash[attr] = send(attr) }
      hash.hash
    end

    alias eql? ==

    def set_equality_conditions
      self.class.send(:attr_readers) + associations
    end

    def collection_counts_to_s
      []
    end

    def public_attr_readers_to_s
      self.class.send(:public_attr_readers).map do |attr|
        value = send(attr)
        "#{attr}: #{stringify_value(value)}"
      end
    end

    def associations_to_s
      []
    end

    def displayable_attributes
      attributes = [
        public_attr_readers_to_s.dup,
        associations_to_s.dup,
        collection_counts_to_s.dup
      ].flatten
      return attributes if attributes.empty?
      attributes.unshift(' ' + attributes.shift)
    end

    def stringify_value(value)
      if value.is_a?(String)
        "\"#{value}\""
      elsif value.nil?
        'nil'
      else
        value
      end
    end

    private :displayable_attributes,
            :stringify_value,
            :public_attr_readers_to_s,
            :collection_counts_to_s,
            :associations_to_s,
            :set_equality_conditions

    # Class methods provided to all LazyRecord classes
    module ClassMethods
      def public_attr_readers
        @public_attr_readers ||= attr_readers.reject do |reader|
          private_method_defined?(reader) || protected_method_defined?(reader)
        end
      end

      def attr_readers
        @attr_readers ||= []
      end

      def all
        @all ||= Relation.new(model: self)
      end

      def count
        all.count
      end

      def first
        all.first
      end

      def last
        all.last
      end

      def where(condition = nil, &block)
        all.where(condition, &block)
      end

      def destroy_all
        all.send(:clear)
      end
    end
  end
end

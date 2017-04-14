# frozen_string_literal: true

module LazyRecord
  # This module gives the Base class its functionality, and can be included
  # in any class as an alternative to inheriting from LazyRecord::Base
  module BaseModule
    # Extend these modules when BaseModule is included
    def self.included(base)
      base.extend ClassMethods
      base.extend Scopes
      base.extend Attributes
      base.extend Associations
      base.extend Callbacks
      base.extend Validations
      base.extend Methods
      base.extend DynamicModules
    end

    attr_writer :id

    # Use options hash to set attributes, and/or operate on object in a block.
    # Checks each options key for a matching attribute setter method.
    def initialize(opts = {})
      opts.each do |key, val|
        send("#{key}=", val) if respond_to?("#{key}=")
      end
      yield self if block_given?
    end

    def collection_counts_to_s
      []
    end

    def public_attr_readers_to_s
      @public_attr_readers_to_s ||=
        self.class.send(:public_attr_readers).map do |attr|
          value = send(attr)
          "#{attr}: #{stringify_value(value)}"
        end
    end

    def has_one_associations_to_s
      []
    end

    def inspect
      format('#<%s id: %s%s%s%s>',
             self.class,
             display_id_even_if_nil,
             public_attr_readers_to_s.unshift('').join(', '),
             has_one_associations_to_s.unshift('').join(', '),
             collection_counts_to_s.unshift('').join(', '))
    end

    def display_id_even_if_nil
      id ? id.to_s : 'nil'
    end

    def id
      @id.freeze
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

    private :id=,
            :display_id_even_if_nil,
            :stringify_value,
            :public_attr_readers_to_s,
            :collection_counts_to_s

    # Class methods provided to all LazyRecord classes
    module ClassMethods
      def public_attr_readers
        @public_attr_readers ||= []
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

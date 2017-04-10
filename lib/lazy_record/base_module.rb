# frozen_string_literal: true

module LazyRecord
  # This module gives the Base class its functionality, and can be included
  # in any class as an alternative to inheriting from LazyRecord::Base
  module BaseModule
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

    def initialize(opts = {})
      opts.each do |k, v|
        send("#{k}=", v) if respond_to?("#{k}=")
      end
      yield self if block_given?
    end

    def instance_attrs_to_s
      []
    end

    def instance_attr_accessors
      []
    end

    def collection_counts_to_s
      []
    end

    def has_one_associations_to_s
      []
    end

    def inspect
      "#<#{self.class} id: #{id ? id : 'nil'}"\
      "#{instance_attrs_to_s.unshift('').join(', ')}"\
      "#{has_one_associations_to_s.unshift('').join(', ')}"\
      "#{collection_counts_to_s.unshift('').join(', ')}>"
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
            :stringify_value,
            :instance_attrs_to_s,
            :instance_attr_accessors,
            :collection_counts_to_s

    # Class methods provided to all LazyRecord classes
    module ClassMethods
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

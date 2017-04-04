# frozen_string_literal: true

module LazyRecord
  # This module gives the Base class its functionality, and can be included
  # in any class as an alternative to inheriting from LazyRecord::Base
  module BaseModule
    def self.included(base)
      base.extend(
        ClassMethods,
        Scopes,
        Attributes,
        Associations,
        Callbacks,
        Validations,
        Methods,
        DynamicModules
      )
    end

    attr_writer :id

    def initialize(_opts = {})
      yield self if block_given?
    end

    def instance_attrs_to_s
      []
    end

    def instance_attr_accessors
      []
    end

    def inspect
      "#<#{self.class} id: #{id ? id : 'nil'}"\
      "#{instance_attrs_to_s.unshift('').join(', ')}>"
    end

    def id
      @id.freeze
    end

    private :id=

    # Class methods provided to all LazyRecord classes
    module ClassMethods
      attr_reader :all

      def count
        @all.count
      end

      def first
        @all.first
      end

      def last
        @all.last
      end

      def where(condition)
        @all.where(condition)
      end

      def destroy_all
        @all.send(:clear)
      end
    end
  end
end

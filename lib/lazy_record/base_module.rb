# frozen_string_literal: true
module LazyRecord
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

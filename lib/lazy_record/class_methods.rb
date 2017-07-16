# frozen_string_literal: true

module LazyRecord
  # Class methods extended to all LazyRecord descendants.
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
      @all ||= Relation.new(klass: self)
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

# frozen_string_literal: true
class LazyRecord
  class Relation < Array
    attr_reader :model

    def initialize(model:, array: nil)
      raise ArgumentError, "model must be a class" unless model.is_a?(Class)
      @model = model
      self_extend_scopes_module
      array.each { |object| self << object } if array
    end

    def <<(other)
      unless other.is_a?(model)
        raise ArgumentError, "object must be of type #{model}"
      else
        super
      end
    end

    def inspect
      "\#<#{model}Relation [#{self.map(&:inspect).join(', ')}]>"
    end

    def where(condition)
      result = select { |x| eval "x.#{condition}" }
      self.class.new(model: model, array: result)
    end

    def self_extend_scopes_module
      if model.const_defined?(:ScopeMethods, _search_ancestors = false)
        mod = eval("#{model}::ScopeMethods")
        extend(mod)
      end
    end
  end
end
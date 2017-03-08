# frozen_string_literal: true
module LazyRecord
  class Relation
    include Enumerable

    attr_reader :model, :all

    def initialize(model:, array: nil)
      raise ArgumentError, "model must be a class" unless model.is_a?(Class)
      @model = model
      @all   = []
      self_extend_scopes_module
      array.each { |object| @all << object } if array
    end

    def <<(other)
      unless other.is_a?(model)
        raise ArgumentError, "object must be of type #{model}"
      else
        all << other
      end
    end

    def inspect
      "\#<#{model}Relation [#{all.map(&:inspect).join(', ')}]>"
    end

    def where(condition)
      result = all.select { |x| eval "x.#{condition}" }
      self.class.new(model: model, array: result)
    end

    def each(&block)
      all.each(&block)
    end

    def [](index)
      all[index]
    end

    def last
      self[-1]
    end

    def clear
      all.clear
    end

    private :clear, :all

    def self_extend_scopes_module
      if model.const_defined?(:ScopeMethods, _search_ancestors = false)
        mod = eval("#{model}::ScopeMethods")
        extend(mod)
      end
    end
  end
end

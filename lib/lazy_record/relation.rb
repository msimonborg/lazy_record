# frozen_string_literal: true

module LazyRecord
  # Collection of LazyRecord objects that are bound to a single class.
  # The Relation inherits scope methods from the class it is bound to.
  class Relation
    include Enumerable

    attr_reader :model, :all

    def initialize(model:, array: nil)
      model = model.call if model.is_a? Proc
      raise ArgumentError, 'model must be a class' unless model.is_a?(Class)
      @model = model
      @all   = []
      self_extend_scopes_module
      array&.each do |object|
        @all << object && next if object.is_a?(model)
        message = "Argument must be a collection of #{model.to_s.tableize}"
        raise ArgumentError, message
      end
    end

    def <<(other)
      message = "object must be of type #{model}"
      raise ArgumentError, message unless other.is_a?(model)
      all << other unless all.include?(other)
    end

    def inspect
      "\#<#{model}Relation [#{all.map(&:inspect).join(', ')}]>"
    end

    def where(condition = nil)
      result = all.select do |instance|
        if condition.is_a? Hash
          select_by_hash_condition(condition, instance)
        elsif block_given?
          yield instance
        end
      end
      self.class.new(model: model, array: result)
    end

    def select_by_hash_condition(condition, instance)
      condition.all? do |key, val|
        val = val.call if val.is_a? Proc
        instance.send(key) == val
      end
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

    def empty?
      all.empty?
    end

    def clear
      all.clear
    end

    private :clear, :all, :select_by_hash_condition

    def self_extend_scopes_module
      return unless model.const_defined?(Scopes::SCOPE_MODULE_NAME,
                                         _search_ancestors = false)
      extend(model.const_get(Scopes::SCOPE_MODULE_NAME))
    end
  end
end

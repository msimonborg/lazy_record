# frozen_string_literal: true

module LazyRecord
  # Collection of LazyRecord objects that are bound to a single class.
  # The Relation inherits scope methods from the class it is bound to.
  class Relation
    include Enumerable

    attr_reader :klass, :all

    def initialize(klass:, collection: [])
      klass = klass.call if klass.is_a? Proc
      klass_argument_error unless klass.is_a?(Class)
      @klass = klass
      @all   = []
      self_extend_scopes_module
      collection.each do |object|
        @all << object && next if object.is_a?(klass)
        collection_argument_error
      end
    end

    def collection_argument_error
      message = "Argument must be a collection of #{klass.to_s.tableize}"
      raise ArgumentError, message
    end

    def klass_argument_error
      raise ArgumentError, '`klass` keyword argument must be a class'
    end

    def <<(other)
      message = "object must be of type #{klass}"
      raise ArgumentError, message unless other.is_a?(klass)
      all << other unless all.include?(other)
    end

    def inspect
      "\#<#{klass}Relation [#{all.map(&:inspect).join(', ')}]>"
    end

    def where(condition = nil)
      result = all.select do |instance|
        if condition.is_a? Hash
          select_by_hash_condition(condition, instance)
        elsif block_given?
          yield instance
        end
      end
      self.class.new(klass: klass, collection: result)
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
      return unless klass.const_defined?(Scopes::SCOPE_MODULE_NAME,
                                         _search_ancestors = false)
      extend(klass.const_get(Scopes::SCOPE_MODULE_NAME))
    end
  end
end

# frozen_string_literal: true

module LazyRecord
  # Macro for dynamic instance method generation. Best to use for one-liners.
  module Methods
    METHODS_MODULE_NAME = :DynamicMethods

    # Defines an instance method on the calling class. The first argument
    # is a symbol that names the method. The second argument should be a lambda
    # that defines the method execution. The method argument could technically
    # be any object that responds to #to_proc and returns a Proc, but lambdas
    # with their arity restrictions are preferred.
    #
    # === Example
    #   class Thing < LazyRecord::Base
    #     lazy_method :say_hi, -> { "Hi from #{self}" }
    #   end
    #
    #   thing = Thing.new # => #<Thing>
    #   thing.say_hi      # => "Hi from #<Thing:0x007fb9629c6260>"
    #
    # @api public
    #
    # @param method_name [Symbol, String]
    # @param method [Proc]
    #
    # @return [Symbol]
    def lazy_method(method_name, method)
      mod = get_or_set_mod(METHODS_MODULE_NAME)

      mod.module_eval do
        define_method(method_name.to_sym, &method)
      end

      include mod unless include?(mod)
    end

    def lr_method(method_name, method) # Will be removed in version 1.0.0
      puts 'Using `.lr_method` is deprecated. Use '\
      '`lazy_method` instead. `.lr_method` will be removed in version 1.0.0'
      lazy_method(method_name, method)
    end

    undef_method(:lr_method) if LazyRecord::VERSION >= '1.0.0'
  end
end

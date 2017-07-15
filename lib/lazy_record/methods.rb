# frozen_string_literal: true

module LazyRecord
  # Macro for dynamic instance method generation. Best to use for one-liners.
  module Methods
    METHODS_MODULE_NAME = :DynamicMethods

    # Defines an instance method on the calling class. The first agrument
    # is a symbol that names the method. The second method should be a lambda
    # that defines the method execution. The first argument yielded to the
    # lambda is the receiving object. The method object could technically
    # be any object, but lambdas with their arity restrictions are preferred.
    #
    # === Example
    #   class Thing < LazyRecord::Base
    #     lr_method :say_hi, ->(obj) { "Hi from #{obj}" }
    #   end
    #
    #   thing = Thing.new # => #<Thing>
    #   thing.say_hi      # => "Hi from #<Thing:0x007fc7b78623e8>"
    #
    # @api public
    #
    # @param method_name [Symbol, String]
    # @param method [Lambda]
    #
    # @return [Symbol]
    def lr_method(method_name, method)
      mod = get_or_set_mod(METHODS_MODULE_NAME)

      mod.module_eval do
        define_method(method_name.to_sym) do |*args|
          method.call(self, *args)
        end
      end

      include mod unless include?(mod)
    end
  end
end

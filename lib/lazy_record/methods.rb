# frozen_string_literal: true
module LazyRecord
  # Macro for dynamic instance method generation. Best to use for one-liners.
  module Methods
    METHODS_MODULE_NAME = :DynamicMethods

    def can_multiply
      mod = get_or_set_and_include_mod(METHODS_MODULE_NAME)

      mod.module_eval do
        define_method(:multiply) do |num1, num2|
          num1 * num2
        end
      end
    end

    def my_method(method_name, *args, method)
      mod = get_or_set_and_include_mod(METHODS_MODULE_NAME)

      args = args.map(&:to_s).join(', ')

      if method.respond_to?(:call)
        mod.module_eval do
          send(:define_method, method_name, &method)
        end
      else
        mod.module_eval do
          define_method(method_name) do |*params|
            block = eval("lambda { |#{args}| #{method} }")
            block.call(*params)
          end
        end
      end
    end
  end
end

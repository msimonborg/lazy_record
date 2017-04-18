# frozen_string_literal: true

module LazyRecord
  # Macro for dynamic instance method generation. Best to use for one-liners.
  module Methods
    METHODS_MODULE_NAME = :DynamicMethods

    def lr_method(method_name, method)
      include mod = get_or_set_mod(METHODS_MODULE_NAME)

      mod.module_eval do
        define_method(method_name) do |*args|
          method.call(self, *args)
        end
      end
    end
  end
end

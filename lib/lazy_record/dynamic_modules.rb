# frozen_string_literal: true
module LazyRecord
  # Generate dynamic modules for dynamic methods created with #define_method,
  # for insertion into inheritance chain. This allows you to make calls to
  # super for these methods.
  module DynamicModules
    def get_or_set_and_include_mod(module_name)
      if const_defined?(module_name, _search_ancestors = false)
        const_get(module_name)
      else
        mod = const_set(module_name, Module.new)
        include mod
        mod # return the Module for variable assignment.
      end
    end

    def get_or_set_mod(module_name)
      if const_defined?(module_name, _search_ancestors = false)
        const_get(module_name)
      else
        mod = const_set(module_name, Module.new)
      end
    end
  end
end

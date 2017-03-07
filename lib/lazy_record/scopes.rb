# frozen_string_literal: true
module LazyRecord
  # Add ActiveRecord-style scope macros to your classes. Allows chaining.
  module Scopes
    SCOPE_MODULE_NAME = :ScopeMethods

    def lr_scope(method_name, lambda)
      if const_defined?(SCOPE_MODULE_NAME, _search_ancestors = false)
        mod = const_get(SCOPE_MODULE_NAME)
      else
        mod = const_set(SCOPE_MODULE_NAME, Module.new)
        extend mod
      end

      mod.module_eval do
        send(:define_method, method_name, &lambda)
      end
    end
  end
end

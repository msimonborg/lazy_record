# frozen_string_literal: true

module LazyRecord
  # Add ActiveRecord-style scope macros to your classes. Allows chaining.
  module Scopes
    SCOPE_MODULE_NAME = :ScopeMethods

    def lazy_scope(method_name, lambda)
      extend mod = get_or_set_mod(SCOPE_MODULE_NAME)

      mod.module_eval do
        define_method(method_name, &lambda)
      end
    end

    def lr_scope(method_name, lambda) # Will be removed in version 1.0.0
      puts 'Using `.lr_scope` is deprecated. Use '\
      '`lazy_scope` instead. `.lr_scope` will be removed in version 1.0.0'
      lazy_scope(method_name, lambda)
    end

    undef_method(:lr_scope) if LazyRecord::VERSION >= '1.0.0'
  end
end

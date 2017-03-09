# frozen_string_literal: true
require 'lazy_record/dynamic_modules'

module LazyRecord
  # After #initialize callbacks for validations and setting object id.
  module Callbacks
    CALLBACKS_MODULE_NAME = :DynamicCallbacks

    extend DynamicModules

    def self.define_new_method
      lambda do
        define_method(:new) do |opts = {}, &block|
          @all ||= Relation.new(model: self)
          instance = super(opts, &block)
          if instance.respond_to?(:validation)
            instance = instance.validation(*@validations)
          end
          add_id(instance)
        end
      end
    end

    def self.define_add_id_method
      lambda do
        define_method(:add_id) do |instance|
          if instance
            all << instance
            instance.send(:id=, count)
          end
          instance
        end
        private :add_id
      end
    end

    def self.extended(base_mod)
      define_new_proc    = define_new_method
      define_add_id_proc = define_add_id_method

      dynamic_mod = get_or_set_mod(CALLBACKS_MODULE_NAME)
      dynamic_mod.module_eval do
        define_new_proc.call
        define_add_id_proc.call
      end

      base_mod.extend(dynamic_mod)
    end
  end
end

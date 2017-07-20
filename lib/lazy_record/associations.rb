# frozen_string_literal: true

require 'lazy_record/nesting'

module LazyRecord
  # Set up in-memory one-to-one associations between POROs.
  module Associations
    include LazyRecord::Nesting

    ASSOCIATION_MODULE_NAME = :Associations

    def lr_has_one(*args)
      include mod = get_or_set_mod(ASSOCIATION_MODULE_NAME)
      mod.extend(Associations) unless mod.const_defined?('Associations')
      mod.module_eval { add_has_one_methods(args) }
    end

    def add_has_one_methods(args)
      define_has_one_associations(*args)
      define_has_one_associations_to_s
      args.each do |association|
        define_association_setter(association)
        define_association_getter(association)
      end
    end

    def define_has_one_associations(*args)
      define_method(:associations) do
        args
      end
    end

    def define_has_one_associations_to_s
      define_method(:associations_to_s) do
        associations.map do |association|
          "#{association}: #{stringify_value(send(association))}"
        end
      end
      private :associations_to_s
    end

    def define_association_setter(assoc)
      klass = lazily_get_class(assoc.to_s.camelize).call
      define_method("#{assoc}=") do |val|
        return instance_variable_set("@#{assoc}", val) if val.is_a? klass
        raise ArgumentError, "Argument must be a #{klass}"
      end
    end

    def define_association_getter(association)
      define_method(association) do
        instance_variable_get("@#{association}")
      end
    end
  end
end

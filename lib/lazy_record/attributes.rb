# frozen_string_literal: true

module LazyRecord
  # Add special attr_accessors that automatically add initialization options
  # to your initialize method. Using lr_attr_accessor, you automatically get
  # an #initialize method that takes setter options for each attribute and
  # yields self to a block. If you want to add custom functionality to
  # #initialize just call super.
  module Attributes
    ATTR_MODULE_NAME = :DynamicAttributes

    def define_setters_and_getters(name)
      define_method(name) do
        instance_variable_get('@' + name.to_s)
      end

      define_method("#{name}=") do |val|
        instance_variable_set('@' + name.to_s, val)
      end
    end

    def define_initialize
      define_method(:initialize) do |opts = {}, &block|
        opts = opts.inject({}) do |memo, (k,v)|
          memo[k.to_sym] = v
          memo
        end

        instance_attr_accessors.each do |attr|
          send("#{attr}=", opts[attr.to_sym])
        end

        block&.call self
        self
      end
    end

    def define_instance_attrs_to_s
      define_method(:instance_attrs_to_s) do
        instance_attr_accessors.map do |attr|
          value = send(attr)
          attr_to_s = stringify_value(value)
          "#{attr.to_s.delete(':')}: #{attr_to_s}"
        end
      end
      private :instance_attrs_to_s
    end

    def define_stringify_value
      define_method(:stringify_value) do |value|
        if value.is_a?(String)
          "\"#{value}\""
        elsif value.nil?
          'nil'
        else
          value
        end
      end
    end

    def define_instance_attr_accessors(*names)
      define_method(:instance_attr_accessors) do
        names.map(&:to_sym)
      end
      private :instance_attr_accessors
    end

    def lr_attr_accessor(*names)
      include mod = get_or_set_mod(ATTR_MODULE_NAME)
      mod.extend(Attributes)
      mod.module_eval do
        names.each { |name| define_setters_and_getters(name) }
        define_instance_attr_accessors(*names)
        define_initialize
        define_instance_attrs_to_s
        define_stringify_value
      end
    end
  end
end

# frozen_string_literal: true
module LazyRecord
  # Add special attr_accessors that automatically add initialization options
  # to your initialize method. Using lr_attr_accessor, you automatically get
  # an #initialize method that takes setter options for each attribute and
  # yields self to a block. If you want to add custom functionality to
  # #initialize just call super.
  module Attributes
    ATTR_MODULE_NAME = :DynamicAttributes

    def define_setters_and_getters
      proc do |name|
        define_method(name) do
          instance_variable_get('@' + name.to_s)
        end

        define_method("#{name}=") do |val|
          instance_variable_set('@' + name.to_s, val)
        end
      end
    end

    def define_initialize
      proc do
        define_method(:initialize) do |opts = {}, &block|
          binding.pry
          instance_attr_accessors.each do |attr|
            send("#{attr}=", opts[attr.to_sym])
          end

          block.call self if block
          self
        end
      end
    end

    def define_instance_attrs_to_s
      proc do
        define_method(:instance_attrs_to_s) do
          instance_attr_accessors.map do |attr|
            value = send(attr)
            attr_to_s = if value.is_a?(String)
                          "\"#{value}\""
                        elsif value.nil?
                          'nil'
                        else
                          value
                        end
            "#{attr.to_s.delete(':')}: #{attr_to_s}"
          end
        end
        private :instance_attrs_to_s
      end
    end

    def define_instance_attr_accessors
      proc do |*names|
        define_method(:instance_attr_accessors) do
          names.map(&:to_sym)
        end
        private :instance_attr_accessors
      end
    end


    def lr_attr_accessor(*names)
      mod                     = get_or_set_and_include_mod(ATTR_MODULE_NAME)
      setters_and_getters     = define_setters_and_getters
      init                    = define_initialize
      instance_attrs_to_s     = define_instance_attrs_to_s
      instance_attr_accessors = define_instance_attr_accessors

      mod.module_eval do
        names.each do |name|
          setters_and_getters.call(name)
        end
        instance_attr_accessors.call(*names)
        init.call
        instance_attrs_to_s.call
      end
    end
  end
end

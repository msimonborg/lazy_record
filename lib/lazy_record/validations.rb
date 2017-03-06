# frozen_string_literal: true
class LazyRecord
  # Validations callbacks. If validations don't pass then initialization
  # will return false.
  module Validations
    VALIDATIONS_MODULE_NAME = :ModelValidations

    def my_validates(*args)
      mod = get_or_set_and_include_mod(VALIDATIONS_MODULE_NAME)

      opts = args.extract_options!
      @validations = args
      if opts[:presence] == true

        mod.module_eval do
          define_method(:validation) do |*params|
            params.each do |param|
              begin
                raise ArgumentError if send(param.to_sym).nil?
              rescue => e
                puts e, "#{arg} must be given", inspect
                return false
              end
            end
            self
          end
        end
      end
    end
  end
end

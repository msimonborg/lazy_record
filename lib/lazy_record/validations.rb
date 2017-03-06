# frozen_string_literal: true
module LazyRecord
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
          define_method(:validation) do |*args|
            args.each do |arg|
              begin
                raise ArgumentError if send(arg.to_sym).nil?
              rescue => e
                puts e, "#{arg} must be given", self.inspect
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
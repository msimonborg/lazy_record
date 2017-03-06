# frozen_string_literal: true
module LazyRecord
  # After #initialize callbacks for validations and setting object id.
  module Callbacks
    def inherited(klass)
      class << klass
        alias_method :__new, :new

        def new(opts = {}, &block)
          @all ||= Relation.new(model: self)
          instance = __new(opts, &block)
          if instance.respond_to?(:validation)
            instance = instance.validation(*@validations)
          end
          add_id(instance)
        end

        def add_id(instance)
          if instance
            all << instance
            instance.send(:id=, count)
          end
          instance
        end

        private :add_id
      end
    end
  end
end

# frozen_string_literal: true

require 'lazy_record/dynamic_modules'

module LazyRecord
  # After #initialize callbacks for validations and setting object id.
  module Callbacks
    def new(opts = {})
      @all ||= Relation.new(klass: self)
      instance = super(opts)
      if instance.respond_to?(:validation)
        instance = instance.validation(*@validations)
      end
      instance.tap { |inst| all << inst if inst }
    end
  end
end

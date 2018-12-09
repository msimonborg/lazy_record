# frozen_string_literal: true

module LazyRecord
  # Add special attr_accessors that automatically add initialization options
  # to your initialize method. Using lr_attr_accessor, you automatically get
  # an #initialize method that takes setter options for each attribute and
  # yields self to a block. If you want to add custom functionality to
  # #initialize just call super.
  module Attributes
    def attr_accessor(*names)
      super(*names)
      add_to_attr_readers(*names)
    end

    def attr_reader(*names)
      super(*names)
      add_to_attr_readers(*names)
    end

    def add_to_attr_readers(*names)
      names.each do |name|
        attr_readers << name.to_sym
      end
    end
  end
end

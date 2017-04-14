# frozen_string_literal: true

module LazyRecord
  # Add special attr_accessors that automatically add initialization options
  # to your initialize method. Using lr_attr_accessor, you automatically get
  # an #initialize method that takes setter options for each attribute and
  # yields self to a block. If you want to add custom functionality to
  # #initialize just call super.
  module Attributes
    def lr_attr_accessor(*names) # TODO: remove in version 1.0.0
      puts 'Using `.lr_attr_accessor` is deprecated. Use the standard `.attr_*`'\
      ' methods instead. You will get the same results, plus the methods will be'\
      ' recognized by rdoc. `.lr_attr_accessor` will be removed in version 1.0.0'
      attr_accessor(*names)
    end

    undef_method(:lr_attr_accessor) if LazyRecord::VERSION == '1.0.0'

    def attr_accessor(*names)
      attr_reader(*names)
      attr_writer(*names)
    end

    def attr_reader(*names)
      super(*names)
      names.each do |name|
        public_attr_readers << name.to_sym if public_method_defined?(name)
      end
    end
  end
end

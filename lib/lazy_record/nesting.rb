# frozen_string_literal: true

module LazyRecord
  # Apply the same namespace nesting as self to another object.
  module Nesting
    def apply_nesting(class_name)
      "#{to_s.split('::')[0..-3].join('::')}::#{class_name}"
    end
  end
end

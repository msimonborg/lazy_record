# frozen_string_literal: true

module LazyRecord
  # Apply the same namespace nesting as self to another object.
  module Nesting
    def apply_nesting(class_name)
      "#{to_s.split('::')[0..-2].join('::')}::#{class_name}"
    end

    def apply_nesting_one_level_back(class_name)
      "#{to_s.split('::')[0..-3].join('::')}::#{class_name}"
    end

    def lazy_const_get(class_name)
      lambda do
        begin
          const_get(class_name)
        rescue NameError
          const_get apply_nesting(class_name)
        end
      end
    end

    def lazy_const_get_one_level_back(class_name)
      lambda do
        begin
          const_get(class_name)
        rescue NameError
          const_get apply_nesting_one_level_back(class_name)
        end
      end
    end
  end
end

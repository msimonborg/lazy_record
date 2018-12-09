# frozen_string_literal: true

module LazyRecord
  # Deprecated methods
  module Deprecations
    DEPRECATED_METHODS = %i[
      lr_has_many
      lr_accepts_nested_attributes_for
      lr_validates
      lr_scope
      lr_method
      lr_attr_accessor
      lr_has_one
    ].freeze

    def lr_has_many(*collections)
      puts 'Using `.lr_has_many` is deprecated. Use '\
      '`lazy_has_many` instead. `.lr_has_many` will be removed in version 1.0.0'
      lazy_has_many(*collections)
    end

    def lr_accepts_nested_attributes_for(*collections)
      puts 'Using `.lr_accepts_nested_attributes_for` is deprecated. Use '\
      '`lazy_accepts_nested_attributes_for` instead. '\
      '`.lr_accepts_nested_attributes_for` will be removed in version 1.0.0'
      lazy_accepts_nested_attributes_for(*collections)
    end

    def lr_validates(*args)
      puts 'Using `.lr_validates` is deprecated. Use '\
      '`lazy_validates` instead. `.lr_validates` will be '\
      'removed in version 1.0.0'
      lazy_validates(*args)
    end

    def lr_scope(method_name, lambda)
      puts 'Using `.lr_scope` is deprecated. Use '\
      '`lazy_scope` instead. `.lr_scope` will be removed in version 1.0.0'
      lazy_scope(method_name, lambda)
    end

    def lr_method(method_name, method)
      puts 'Using `.lr_method` is deprecated. Use '\
      '`lazy_method` instead. `.lr_method` will be removed in version 1.0.0'
      lazy_method(method_name, method)
    end

    def lr_attr_accessor(*names)
      puts 'Using `.lr_attr_accessor` is deprecated. Use the standard '\
      '`.attr_*` methods instead. You will get the same results, plus '\
      'the methods will be recognized by rdoc. `.lr_attr_accessor` will'\
      ' be removed in version 1.0.0'
      attr_accessor(*names)
    end

    def lr_has_one(*args)
      puts 'Using `.lr_has_one` is deprecated. Use '\
      '`lazy_has_one` instead. `.lr_has_one` will be removed in version 1.0.0'
      lazy_has_one(*args)
    end

    if LazyRecord::VERSION >= '1.0'
      DEPRECATED_METHODS.each { |meth| undef_method(meth) }
    end
  end
end

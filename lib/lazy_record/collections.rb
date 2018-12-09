# frozen_string_literal: true

require 'lazy_record/nesting'

module LazyRecord
  # Set up in-memory one-to-many relationships between objects
  module Collections
    include LazyRecord::Nesting

    COLLECTION_MODULE_NAME   = :Collections
    NESTED_ATTRS_MODULE_NAME = :NestedAttributes

    def _define_collection_getter(collection, options)
      klass = lazy_const_get_one_level_back(options[:class_name]).call
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}
          @#{collection} ||= Relation.new(klass: #{klass})
        end
      RUBY
    end

    def _define_collection_setter(collection, options)
      klass = lazy_const_get_one_level_back(options[:class_name]).call
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}=(coll)
          @#{collection} = Relation.new(klass: #{klass}, collection: coll)
        end
      RUBY
    end

    def _define_collection_counter(collection)
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}_count
          #{collection}.count
        end
      RUBY
    end

    def _add_to_collections(*collections)
      options = collections.extract_options!
      collections.each do |collection|
        class_name = options[:class_name] || collection.to_s.classify
        _collections[collection.to_sym] = { class_name: class_name }
      end
    end

    def _collections
      @_collections ||= {}
    end

    def _define_collection_counts_to_s
      define_method(:collection_counts_to_s) do
        collections.map do |collection, _options|
          "#{collection}_count: #{stringify_value(send("#{collection}_count"))}"
        end
      end
      private :collection_counts_to_s
    end

    def _define_collections
      collections = _collections
      define_method(:collections) { collections }
    end

    def lazy_has_many(*collections)
      include mod = get_or_set_mod(COLLECTION_MODULE_NAME)
      mod.extend(Collections)
      mod.module_eval { _add_collection_methods(*collections) }
    end

    def lr_has_many(*collections) # Will be removed in version 1.0.0
      puts 'Using `.lr_has_many` is deprecated. Use '\
      '`lazy_has_many` instead. `.lr_has_many` will be removed in version 1.0.0'
      lazy_has_many(*collections)
    end

    undef_method(:lr_has_many) if LazyRecord::VERSION >= '1.0.0'

    def _add_collection_methods(*collections)
      _add_to_collections(*collections)
      _define_collections
      _define_collection_counts_to_s
      _collections.each do |collection, options|
        _define_collection_getter(collection, options)
        _define_collection_setter(collection, options)
        _define_collection_counter(collection)
      end
    end

    def define_collection_attributes_setter(collection, options)
      class_name = lazy_const_get_one_level_back(
        options.fetch(:class_name)
      ).call
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}_attributes=(collection_attributes)
          collection_attributes.values.each do |attributes|
            #{collection} << #{class_name}.new(attributes)
          end
        end
      RUBY
    end

    def lazy_accepts_nested_attributes_for(*collections)
      include mod = get_or_set_mod(COLLECTION_MODULE_NAME)
      mod.extend(Collections)
      mod.module_eval do
        collections.each do |collection|
          options = _collections[collection]
          _no_collection_error(collection) unless options
          define_collection_attributes_setter(collection, options)
        end
      end
    end

    def lr_accepts_nested_attributes_for(*collections) # Will be removed in version 1.0.0
      puts 'Using `.lr_accepts_nested_attributes_for` is deprecated. Use '\
      '`lazy_accepts_nested_attributes_for` instead. `.lr_accepts_nested_attributes_for` '\
      'will be removed in version 1.0.0'
      lazy_accepts_nested_attributes_for(*collections)
    end

    undef_method(:lr_accepts_nested_attributes_for) if LazyRecord::VERSION >= '1.0.0'

    def _no_collection_error(collection)
      klass = collection.to_s.classify
      klass = _collections.find { |_col, opt| opt[:class_name] == klass }.first
      suggestion = klass ? ". Did you mean #{klass}?" : ''
      msg = "#{self} doesn't have a collection of #{collection}#{suggestion}"
      raise ArgumentError, msg, caller
    end
  end
end

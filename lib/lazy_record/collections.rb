# frozen_string_literal: true

module LazyRecord
  # Set up in-memory one-to-many relationships between objects
  module Collections
    COLLECTION_MODULE_NAME   = :Collections
    NESTED_ATTRS_MODULE_NAME = :NestedAttributes

    def _define_collection_getter(collection)
      klass = collection[:class_name].constantize
      collection = collection[:attribute]
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}
          @#{collection} ||= Relation.new(klass: #{klass})
        end
      RUBY
    end

    def _define_collection_setter(collection)
      klass = const_get(collection[:class_name])
      collection = collection[:attribute]
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}=(coll)
          @#{collection} = Relation.new(klass: #{klass}, collection: coll)
        end
      RUBY
    end

    def _define_collection_counter(collection)
      collection = collection[:attribute]
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
        _collections << {
          attribute: collection.to_sym, class_name: class_name
        }
      end
    end

    def _collections
      @_collections ||= []
    end

    def _define_collection_counts_to_s
      define_method(:collection_counts_to_s) do
        collections.map do |collection|
          collection = collection[:attribute]
          "#{collection}_count: #{stringify_value(send("#{collection}_count"))}"
        end
      end
      private :collection_counts_to_s
    end

    def _define_collections
      collections = _collections
      define_method(:collections) { collections }
    end

    def lr_has_many(*collections)
      include mod = get_or_set_mod(COLLECTION_MODULE_NAME)
      mod.extend(Collections)
      mod.module_eval { _add_collection_methods(*collections) }
    end

    def _add_collection_methods(*collections)
      _add_to_collections(*collections)
      _define_collections
      _define_collection_counts_to_s
      _collections.each do |collection|
        _define_collection_getter(collection)
        _define_collection_setter(collection)
        _define_collection_counter(collection)
      end
    end

    def define_collection_attributes_setter(collection, class_name)
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{collection}_attributes=(collection_attributes)
          collection_attributes.values.each do |attributes|
            #{collection} << #{class_name}.new(attributes)
          end
        end
      RUBY
    end

    def lr_accepts_nested_attributes_for(*collections)
      include mod = get_or_set_mod(COLLECTION_MODULE_NAME)
      mod.extend(Collections)
      mod.module_eval do
        collections.each do |collection|
          collection_object = _collections.find do |coll|
            coll[:attribute] == collection
          end
          class_name = collection_object[:class_name].constantize
          define_collection_attributes_setter(collection, class_name)
        end
      end
    end
  end
end

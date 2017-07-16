# frozen_string_literal: true

module LazyRecord
  # Set up in-memory one-to-many relationships between objects
  module Collections
    COLLECTION_MODULE_NAME   = :Collections
    NESTED_ATTRS_MODULE_NAME = :NestedAttributes

    def define_collection_getter(collection)
      klass = const_get(collection.to_s.classify)
      define_method(collection) do
        if instance_variable_get("@#{collection}").nil?
          instance_variable_set("@#{collection}", Relation.new(klass: klass))
        end
        instance_variable_get("@#{collection}")
      end
    end

    def define_collection_setter(collection)
      klass = const_get(collection.to_s.classify)
      define_method("#{collection}=") do |coll|
        coll = Relation.new(klass: klass, collection: coll)
        instance_variable_set("@#{collection}", coll)
      end
    end

    def define_collection_counter(collection)
      define_method("#{collection}_count") do
        send(collection).count
      end
    end

    def define_collections(*collections)
      define_method(:collections) do
        collections
      end
    end

    def define_collection_counts_to_s
      define_method(:collection_counts_to_s) do
        collections.map do |collection|
          "#{collection}_count: #{stringify_value(send("#{collection}_count"))}"
        end
      end
      private :collection_counts_to_s
    end

    def lr_has_many(*collections)
      include mod = get_or_set_mod(COLLECTION_MODULE_NAME)
      mod.extend(Collections)
      mod.module_eval { add_collection_methods(collections) }
    end

    def add_collection_methods(collections)
      define_collections(*collections)
      define_collection_counts_to_s
      collections.each do |collection|
        define_collection_getter(collection)
        define_collection_setter(collection)
        define_collection_counter(collection)
      end
    end

    def define_collection_attributes_setter(collection, class_name)
      define_method("#{collection}_attributes=") do |collection_attributes|
        collection_attributes.values.each do |attributes|
          send(collection) << class_name.new(attributes)
        end
        collection
      end
    end

    def lr_accepts_nested_attributes_for(*collections)
      include mod = get_or_set_mod(NESTED_ATTRS_MODULE_NAME)
      mod.extend(Collections)
      mod.module_eval do
        collections.each do |collection|
          class_name = collection.to_s.classify.constantize
          define_collection_attributes_setter(collection, class_name)
        end
      end
    end
  end
end

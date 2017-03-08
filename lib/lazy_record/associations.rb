# frozen_string_literal: true
module LazyRecord
  # Set up in-memory associations between POROs.
  module Associations
    COLLECTION_MODULE_NAME   = :Collections
    NESTED_ATTRS_MODULE_NAME = :NestedAttributes

    def lr_has_many(*collections)
      mod = get_or_set_and_include_mod(COLLECTION_MODULE_NAME)

      mod.module_eval do
        collections.each do |collection|
          class_constant = collection.to_s.classify.constantize
          define_method(collection) do
            eval "@#{collection} ||= Relation.new(model: class_constant)"
          end

          define_method("#{collection}=") do |coll|
            if coll.is_a? Array
              coll = Relation.new(model: class_constant, array: coll)
            end
            if coll.is_a? Relation
              instance_variable_set('@' + collection.to_s, coll)
            else
              raise ArgumentError, 'Argument must be a collection of '\
              "#{collection}"
            end
          end
        end
      end
    end

    def lr_accepts_nested_attributes_for(*collections)
      mod = get_or_set_and_include_mod(NESTED_ATTRS_MODULE_NAME)

      mod.module_eval do
        collections.each do |collection|
          class_constant = collection.to_s.classify.constantize
          define_method("#{collection}_attributes=") do |collection_attributes|
            collection_attributes.values.each do |attributes|
              eval "@#{collection} << #{class_name}.new(attributes)"
            end
            collection
          end
        end
      end
    end
  end
end

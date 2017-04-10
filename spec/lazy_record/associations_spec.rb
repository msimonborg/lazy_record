# frozen_string_literal: true

describe 'Associations' do
  it_can_include_and_inherit 'Parent', 'Child' do
    Parent.class_eval { lr_has_many :children }

    it 'has many children' do
      expect(Parent.new).to respond_to(:children)
    end

    it '#children returns a ChildRelation' do
      expect(Parent.new.children).to be_a(LazyRecord::Relation)
      expect(Parent.new.children.inspect).to include('ChildRelation')
    end

    it 'the Relation is bound to the Child class' do
      expect(Parent.new.children.model).to eq(Child)
    end

    it 'can set #children as a collection of children' do
      children = []
      10.times { children << Child.new }

      p1 = Parent.new { |p1| p1.children = children }

      expect(p1.children).to be_a(LazyRecord::Relation)
      expect(p1.children.count).to eq(10)
      expect(p1.children.first).to be_a(Child)
    end

    it 'cannot set #children as anything else but a collection of children' do
      non_children = []
      10.times { non_children << Object.new }
      add_non_children = -> { Parent.new { |p| p.children = non_children } }
      add_non_child = -> { Parent.new { |p| p.children = Object.new } }
      expect(&add_non_children).to raise_error(ArgumentError, 'Argument must be a collection of children')
      expect(&add_non_child).to raise_error(ArgumentError, 'Argument must be a collection of children')
    end
  end
end

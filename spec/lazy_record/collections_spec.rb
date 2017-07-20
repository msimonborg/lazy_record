# frozen_string_literal: true

describe 'Collections' do
  it_can_include_and_inherit 'Parent', 'Child', 'Sibling' do
    Parent.class_eval do
      lr_has_many :children
      lr_has_many :brothers, class_name: 'Sibling'
      lr_accepts_nested_attributes_for :children, :brothers
    end

    Child.class_eval { attr_accessor :age }
    Sibling.class_eval { attr_accessor :name }

    it 'has many children' do
      expect(Parent.new).to respond_to(:children)
    end

    it 'has many brothers' do
      expect(Parent.new).to respond_to(:brothers)
    end

    it '#children returns a ChildRelation' do
      expect(Parent.new.children).to be_a(LazyRecord::Relation)
      expect(Parent.new.children.inspect).to include('ChildRelation')
    end

    it '#brothers returns a SiblingRelation' do
      expect(Parent.new.brothers).to be_a(LazyRecord::Relation)
      expect(Parent.new.brothers.inspect).to include('SiblingRelation')
    end

    it 'the ChildRelation is bound to the Child class' do
      expect(Parent.new.children.klass).to eq(Child)
    end

    it 'the SiblingRelation is bound to the Sibling class' do
      expect(Parent.new.brothers.klass).to eq(Sibling)
    end

    it 'can set #children as a collection of children' do
      children = []
      10.times { children << Child.new }

      par1 = Parent.new { |p1| p1.children = children }

      expect(par1.children).to be_a(LazyRecord::Relation)
      expect(par1.children.count).to eq(10)
      expect(par1.children.first).to be_a(Child)
    end

    it 'cannot set #children as anything else but a collection of children' do
      non_children = []
      10.times { non_children << Object.new }
      add_non_children = -> { Parent.new { |p| p.children = non_children } }
      add_non_child = -> { Parent.new { |p| p.children = Object.new } }
      expect(&add_non_children).to raise_error(ArgumentError, 'Argument must be a collection of children')
      expect(&add_non_child).to raise_error(NoMethodError)
    end

    it 'can set #brothers as a collection of siblings' do
      brothers = []
      10.times { brothers << Sibling.new }

      par1 = Parent.new { |p1| p1.brothers = brothers }

      expect(par1.brothers).to be_a(LazyRecord::Relation)
      expect(par1.brothers.count).to eq(10)
      expect(par1.brothers.first).to be_a(Sibling)
    end

    it 'cannot set #brothers as anything else but a collection of siblings' do
      non_siblings = []
      10.times { non_siblings << Object.new }
      add_non_siblings = -> { Parent.new { |p| p.brothers = non_siblings } }
      add_non_sibling = -> { Parent.new { |p| p.brothers = Object.new } }
      expect(&add_non_siblings).to raise_error(ArgumentError, 'Argument must be a collection of siblings')
      expect(&add_non_sibling).to raise_error(NoMethodError)
    end

    it 'accepts nested attributes' do
      parent = Parent.new

      parent.children_attributes = { 0 => { age: 11 }, 1 => { age: 12 } }
      parent.brothers_attributes = { 0 => { name: 'Sue' }, 1 => { name: 'Bob' } }

      expect(parent.children_count).to eq 2
      expect(parent.brothers_count).to eq 2
      expect(parent.children.map(&:age)).to eq [11, 12]
      expect(parent.brothers.map(&:name)).to eq %w[Sue Bob]
    end
  end
end

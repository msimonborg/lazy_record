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

    it 'Child instances can be added to a ChildRelation' do
      p1 = Parent.new do |p1|
        10.times { p1.children << Child.new }
      end

      expect(p1.children.count).to eq(10)
    end

    it 'raises an error when a non-Child is added to the relation' do
      expect { Parent.new { |p1| p1.children << Object.new } }.to raise_error(ArgumentError)
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
      not_children = []
      10.times { not_children << Object.new }

      expect { Parent.new { |p| p.children = not_children } }.to raise_error(ArgumentError, 'Argument must be a collection of children')
      expect { Parent.new { |p| p.children = Object.new } }.to raise_error(ArgumentError, 'Argument must be a collection of children')
    end

    it 'can destroy all of its children' do
      p1 = Parent.new do |p1|
        10.times { p1.children << Child.new }
      end
      Child.new
      p1.children.destroy_all

      expect(p1.children.count).to eq(0)
      expect(Child.count).to eq(1)
      expect(Child.last.id).to eq(11)
    end
  end
end

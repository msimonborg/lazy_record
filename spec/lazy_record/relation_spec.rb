# frozen_string_literal: true

describe 'Relations' do
  it_can_include_and_inherit 'Member' do
    it 'can create a Relation bound to the Member class' do
      r = LazyRecord::Relation.new(model: Member)

      expect(r.model).to eq(Member)
    end

    it 'Member instances can be added to a MemberRelation' do
      r = LazyRecord::Relation.new(model: Member).tap do |r|
        10.times { r << Member.new }
      end

      expect(r.count).to eq(10)
      expect(r.first).to be_a(Member)
      expect(r.last).to be_a(Member)
    end

    it 'raises an error when a non-Member is added to the relation' do
      expect { Parent.new { |p1| p1.children << Object.new } }.to raise_error(ArgumentError)
    end

    it 'can be initialized with an array' do
      members = []
      10.times { members << Member.new }
      r = LazyRecord::Relation.new(model: Member, array: members)

      expect(r.count).to eq(10)
      expect(r.first).to be_a(Member)
      expect(r.last).to be_a(Member)
    end

    it 'raises an error if initialized with an array of non-Members' do
      non_members = []
      10.times { non_members << Object.new }
      add_non_members = lambda do
        LazyRecord::Relation.new(model: Member, array: non_members)
      end

      expect(&add_non_members).to raise_error(ArgumentError, 'Argument must be a collection of members')
    end

    it 'is enumerable on its Members' do
    end
  end
end

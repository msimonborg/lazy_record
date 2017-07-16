# frozen_string_literal: true

describe 'Relations' do
  it_can_include_and_inherit 'Member' do
    Member.class_eval { attr_accessor :id }

    let(:rel) { LazyRecord::Relation.new(klass: Member, collection: members) }
    let(:members) { (1..10).map { |n| Member.new id: n } }

    it 'can create a Relation bound to the Member class' do
      expect(rel.klass).to eq(Member)
    end

    it 'Member instances can be added to a MemberRelation' do
      (11..20).each do |n|
        rel << Member.new(id: n)
      end

      expect(rel.count).to eq(20)
      expect(rel.first).to be_a(Member)
      expect(rel.last).to be_a(Member)
    end

    it 'raises an error when a non-Member is added to the relation' do
      expect { rel << Object.new }.to raise_error(ArgumentError)
    end

    it 'can be initialized with an array' do
      members = (1..10).map { Member.new }
      rel     = LazyRecord::Relation.new(klass: Member, collection: members)

      expect(rel.count).to eq(10)
      expect(rel.first).to be_a(Member)
      expect(rel.last).to be_a(Member)
    end

    it 'raises an error if initialized with an array of non-Members' do
      non_members = (1..10).map { Object.new }
      add_non_members = lambda do
        LazyRecord::Relation.new(klass: Member, collection: non_members)
      end

      expect(&add_non_members).to raise_error(ArgumentError, 'Argument must be a collection of members')
    end

    it 'is enumerable on its Members' do
      expect(rel.map(&:object_id)).to eq members.map(&:object_id)
    end
  end
end

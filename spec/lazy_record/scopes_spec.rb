# frozen_string_literal: true

describe LazyRecord::Scopes do
  it_can_include_and_inherit 'ScopesSpec' do
    ScopesSpec.class_eval do
      attr_accessor :attr_one, :attr_two
      lazy_scope :attr_one_eql_one, -> { where attr_one: 1 }
      lazy_scope :attr_two_eql_two, -> { where attr_two: 2 }
      lazy_scope :attr_one_eql, ->(val) { where attr_one: val }
      lazy_scope :attr_two_eql, ->(val) { where attr_two: val }
    end

    let!(:one) { ScopesSpec.new(attr_one: 1, attr_two: 1) }
    let!(:two) { ScopesSpec.new(attr_one: 2, attr_two: 2) }
    let!(:one_and_two) { ScopesSpec.new(attr_one: 1, attr_two: 2) }

    it 'returns a LazyRecord::Relation instance' do
      expect(ScopesSpec.attr_one_eql_one).to be_a LazyRecord::Relation
    end

    it 'returns the right objects for scopes with no arguments' do
      expect(ScopesSpec.attr_one_eql_one).to include one
      expect(ScopesSpec.attr_one_eql_one).to include one_and_two
      expect(ScopesSpec.attr_one_eql_one).not_to include two
    end

    it 'returns the right objects for scopes with arguments' do
      expect(ScopesSpec.attr_one_eql(1)).to include one
      expect(ScopesSpec.attr_one_eql(1)).not_to include two
      expect(ScopesSpec.attr_one_eql(2)).to include two
      expect(ScopesSpec.attr_one_eql(2)).not_to include one
    end

    it 'can chain scopes' do
      expect(ScopesSpec.attr_one_eql_one.attr_two_eql(1)).to include one
      expect(ScopesSpec.attr_one_eql_one.attr_two_eql(1)).not_to include two
      expect(ScopesSpec.attr_one_eql(2).attr_two_eql_two).to include two
      expect(ScopesSpec.attr_one_eql(2).attr_two_eql_two).not_to include one
      expect(ScopesSpec.attr_one_eql_one.attr_two_eql(2)).to include one_and_two
      expect(ScopesSpec.attr_one_eql(1).attr_two_eql_two).to include one_and_two
    end
  end
end

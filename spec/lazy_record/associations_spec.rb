# frozen_string_literal: true

describe LazyRecord::Associations do
  it_can_include_and_inherit 'AssociationsSpec', 'Association' do
    AssociationsSpec.class_eval do
      lr_has_one :association
    end

    let!(:one) { AssociationsSpec.new association: two }
    let!(:two) { Association.new }
    let!(:three) { Association.new }
    let!(:four) { Object.new }

    it 'has one association' do
      expect(one.association).to be two
    end

    it 'can set an object of the specified class as its association' do
      one.association = three
      expect(one.association).not_to be two
      expect(one.association).to be three
    end

    it 'raises an ArgumentError when trying to set the wrong type of association' do
      expect { one.association = four }.to raise_error ArgumentError
      expect { AssociationsSpec.new association: four }.to raise_error ArgumentError
    end
  end
end

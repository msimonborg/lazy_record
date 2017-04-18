# frozen_string_literal: true

describe 'Base' do
  it_can_include_and_inherit 'BaseSpec' do
    BaseSpec.class_eval do
      attr_accessor :id
    end

    it 'has block syntax in #initialize by default' do
      expect { BaseSpec.new { |b| puts b.class } }.to output("BaseSpec\n").to_stdout
    end

    it 'keeps a count of its instances' do
      expect(BaseSpec).to respond_to(:count)
      expect { BaseSpec.new }.to change { BaseSpec.count }.by(1)
    end

    it 'responds to .all and returns a Relation of all instances' do
      b1 = BaseSpec.new
      b2 = BaseSpec.new

      expect(BaseSpec).to respond_to(:all)
      expect(BaseSpec.all.class).to eq(LazyRecord::Relation)
      expect(BaseSpec.all).to include(b1)
      expect(BaseSpec.all).to include(b2)
    end

    it 'can forget about all of its instances' do
      b1 = BaseSpec.new
      b2 = BaseSpec.new

      BaseSpec.destroy_all
      expect(BaseSpec.count).to eq(0)
    end

    it 'can find the first and last instances' do
      BaseSpec.destroy_all
      b1 = BaseSpec.new
      b2 = BaseSpec.new

      expect(BaseSpec.first).to eq(b1)
      expect(BaseSpec.last).to eq(b2)
    end

    it '.where returns a Relation of instances that match the condition' do
      BaseSpec.destroy_all
      b1 = BaseSpec.new id: 1
      b2 = BaseSpec.new id: 2

      expect(BaseSpec.where(id: 2).class).to eq(LazyRecord::Relation)
      expect(BaseSpec.where(id: 2).first).to eq(b2)
      expect(BaseSpec.where('id')).to include(b1)
      expect(BaseSpec.where('id')).to include(b2)
    end

    it 'has a formatted return for #inspect' do
      BaseSpec.destroy_all
      expect(BaseSpec.new(id: 1).inspect).to eq('#<BaseSpec id: 1>')
    end
  end
end

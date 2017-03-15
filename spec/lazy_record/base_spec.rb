# frozen_string_literal: true
describe 'Base' do
  it_can_include_and_inherit 'BaseSpec' do
    it 'has block syntax in #initialize by default' do
      expect { BaseSpec.new { |b| puts b.class } }.to output("BaseSpec\n").to_stdout
    end

    it 'keeps a count of its instances' do
      expect(BaseSpec).to respond_to(:count)
      expect { BaseSpec.new }.to change { BaseSpec.count }.by(1)
    end

    it 'assigns a unique auto-incrementing ID to each instance' do
      b1 = BaseSpec.new
      b2 = BaseSpec.new

      expect(b1).to respond_to(:id)
      expect(b2).to respond_to(:id)
      expect(b1.id).to_not eq(b2.id)
      expect(b2.id - b1.id).to eq(1)
    end

    it 'has a private method #id=' do
      b1 = BaseSpec.new
      b1_id = b1.id
      b1.send(:id=, b1_id + 1)
      expect(b1.id - b1_id).to eq(1)
      expect(b1).not_to respond_to(:id=)
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
      expect(BaseSpec.new.id).to eq(1)
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
      b1 = BaseSpec.new
      b2 = BaseSpec.new

      expect(BaseSpec.where('id == 2').class).to eq(LazyRecord::Relation)
      expect(BaseSpec.where('id == 2').first).to eq(b2)
      expect(BaseSpec.where('id')).to include(b1)
      expect(BaseSpec.where('id')).to include(b2)
    end

    it 'has a private #id= method' do
      expect { BaseSpec.new.id = 2 }.to raise_error(NoMethodError, /private method/)
    end

    it 'has a formatted return for #inspect' do
      BaseSpec.destroy_all
      expect(BaseSpec.new.inspect).to eq('#<BaseSpec id: 1>')
    end
  end
end

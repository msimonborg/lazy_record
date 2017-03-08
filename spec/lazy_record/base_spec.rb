# frozen_string_literal: true
describe 'LazyRecord::Base' do
  it_can_include_and_inherit 'Parent' do
    it 'has block syntax in #initialize by default' do
      expect { Parent.new { |p| puts p.class } }.to output("Parent\n").to_stdout
    end

    it 'keeps a count of its instances' do
      expect(Parent).to respond_to(:count)
      expect { Parent.new }.to change { Parent.count }.by(1)
    end

    it 'assigns a unique auto-incrementing ID to each instance' do
      p1 = Parent.new
      p2 = Parent.new

      expect(p1).to respond_to(:id)
      expect(p2).to respond_to(:id)
      expect(p1.id).to_not eq(p2.id)
      expect(p2.id - p1.id).to eq(1)
    end

    it 'responds to .all and returns a Relation of all instances' do
      p1 = Parent.new
      p2 = Parent.new

      expect(Parent).to respond_to(:all)
      expect(Parent.all.class).to eq(LazyRecord::Relation)
      expect(Parent.all).to include(p1)
      expect(Parent.all).to include(p2)
    end

    it 'can forget about all of its instances' do
      p1 = Parent.new
      p2 = Parent.new

      Parent.destroy_all
      expect(Parent.count).to eq(0)
      expect(Parent.new.id).to eq(1)
    end

    it 'can find the first and last instances' do
      Parent.destroy_all
      p1 = Parent.new
      p2 = Parent.new

      expect(Parent.first).to eq(p1)
      expect(Parent.last).to eq(p2)
    end

    it '.where returns a Relation of instances that match the condition' do
      Parent.destroy_all
      p1 = Parent.new
      p2 = Parent.new

      expect(Parent.where('id == 2').class).to eq(LazyRecord::Relation)
      expect(Parent.where('id == 2').first).to eq(p2)
      expect(Parent.where('id')).to include(p1)
      expect(Parent.where('id')).to include(p2)
    end

    it 'has a private #id= method' do
      expect { Parent.new.id = 2 }.to raise_error(NoMethodError, /private method/)
    end

    it 'has a formatted return for #inspect' do
      Parent.destroy_all
      expect(Parent.new.inspect).to eq('#<Parent id: 1>')
    end
  end
end

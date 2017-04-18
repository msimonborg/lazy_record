# frozen_string_literal: true

describe 'Attributes' do
  it_can_include_and_inherit 'AttributeSpec1' do
    AttributeSpec1.class_eval { attr_accessor :name }

    it 'can set attributes at initialization with an options hash' do
      attr = AttributeSpec1.new(name: 'a name')
      expect(attr.instance_variable_get(:@name)).to eq('a name')
    end

    it 'can set attributes at initialization with block syntax' do
      attr = AttributeSpec1.new { |a| a.name = 'a name' }
      expect(attr.instance_variable_get(:@name)).to eq('a name')
    end

    it 'creates getter methods for attributes' do
      attr = AttributeSpec1.new(name: 'a name')
      expect(attr.name).to eq('a name')
    end

    it 'creates setter methods for attributes' do
      attr = AttributeSpec1.new(name: 'a name')
      attr.name = 'a different name'
      expect(attr.name).to eq('a different name')
    end
  end

  it_can_include_and_inherit 'AttributeSpec2' do
    AttributeSpec2.class_eval do
      attr_accessor :name, :age
    end

    it 'can define multiple attributes on one line' do
      attr = AttributeSpec2.new(name: 'a name', age: 1)
      expect(attr.name).to eq('a name')
      expect(attr.age).to eq(1)
    end

    it 'can combine hash and block syntax' do
      attr = AttributeSpec2.new(name: 'a name') { |a| a.age = 1 }
      expect(attr.name).to eq('a name')
      expect(attr.age).to eq(1)
    end
  end

  it_can_include_and_inherit 'AttributeSpec3' do
    AttributeSpec3.class_eval do
      attr_accessor :name
      attr_accessor :age
    end

    it 'can define multiple attributes on separate lines' do
      attr = AttributeSpec3.new(name: 'a name') { |a| a.age = 1 }
      expect(attr.name).to eq('a name')
      expect(attr.age).to eq(1)
    end
  end

  it_can_include_and_inherit 'AttributeSpec4' do
    context 'String Arguments' do
      AttributeSpec4.class_eval do
        attr_accessor 'name', 'age'
      end

      it 'functions the same when passed strings as arguments' do
        attr = AttributeSpec4.new(name: 'a name') { |a| a.age = 1 }
        expect(attr.name).to eq('a name')
        expect(attr.age).to eq(1)
      end
    end
  end
end

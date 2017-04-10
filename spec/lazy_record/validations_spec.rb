# frozen_string_literal: true

describe 'Validations' do
  it_can_include_and_inherit 'ValidationSpec1' do
    ValidationSpec1.class_eval do
      lr_attr_accessor :name, :age
      lr_validates :name, presence: true
    end

    it 'validates the right attributes and returns false when invalid' do
      valid = ValidationSpec1.new(name: 'v name')
      invalid = ValidationSpec1.new(age: 1)

      expect(valid).to be_a(ValidationSpec1)
      expect(invalid).to_not be_a(ValidationSpec1)
      expect(invalid).to eq(false)
    end

    it 'does not increment the Class object count when invalid' do
      expect { ValidationSpec1.new }.to change { ValidationSpec1.count }.by(0)
      expect { ValidationSpec1.new(name: 'v name') }.to change { ValidationSpec1.count }.by(1)
    end
  end
end

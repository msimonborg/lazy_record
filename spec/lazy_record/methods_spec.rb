# frozen_string_literal: true

describe LazyRecord::Methods do
  it_can_include_and_inherit 'MethodsSpec' do
    MethodsSpec.class_eval do
      lr_method :return_self, -> { self }
      lr_method :name, -> { self.class.name }
      lr_method :speak, ->(phrase) { "#{name}: #{phrase}" }
    end

    it 'can call methods defined by #lr_method, properly scoped' do
      obj = MethodsSpec.new
      expect(obj.return_self).to be obj
      expect(obj.name). to eq 'MethodsSpec'
      expect(obj.speak('Testing')).to eq 'MethodsSpec: Testing'
    end
  end
end

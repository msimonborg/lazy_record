# frozen_string_literal: true

class CallbacksTest
  extend LazyRecord::Callbacks
  attr_accessor :id
  private :id=
  class << self
    attr_reader :all
    define_method :count { @all.count }
  end
  define_method :initialize { |opts = {}, &block| }
end

describe 'Callbacks' do
  it 'adds an auto-incrementing ID to new instances' do
    c1 = CallbacksTest.new
    c2 = CallbacksTest.new

    expect(c1.id).to eq(1)
    expect(c2.id).to eq(2)
  end

  it 'adds a Relation object of new instances to #all class method' do
    c3 = CallbacksTest.new
    c4 = CallbacksTest.new

    expect(CallbacksTest.all).to be_a(LazyRecord::Relation)
    expect(CallbacksTest.count).to eq(4)
    expect(CallbacksTest.all).to include(c3)
    expect(CallbacksTest.all).to include(c4)
  end

  context 'checks for validations' do
    class CallbacksValidationTest < CallbacksTest
      attr_accessor :valid
      attr_accessor :validated

      def initialize(opts = {})
        self.valid = opts[:valid]
      end

      def validation(*_args)
        if valid
          self.validated = true
          self
        else
          false
        end
      end
    end

    it 'validates and returns the instance if valid' do
      valid = CallbacksValidationTest.new(valid: true)

      expect(valid).to be_a(CallbacksValidationTest)
      expect(valid.validated).to be(true)
    end

    it 'validates and returns false if the instance is invalid' do
      invalid = CallbacksValidationTest.new(valid: false)

      expect(invalid).not_to be_a(CallbacksValidationTest)
      expect(invalid).to be(false)
    end
  end
end

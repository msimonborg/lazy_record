# frozen_string_literal: true

describe LazyRecord::Nesting do
  module One
    class Two
      module Three
        extend LazyRecord::Nesting
      end

      module Four; end
    end
  end

  module Five; end

  class Top; end

  describe 'Three' do
    it 'can find One' do
      expect(One::Two::Three.lazily_get_class('One').call). to be One
    end

    it 'can find Four' do
      expect(One::Two::Three.lazily_get_class('Four').call). to be One::Two::Four
    end

    it 'can find Five' do
      expect(One::Two::Three.lazily_get_class('Five').call). to be One::Two::Five
    end
  end
end

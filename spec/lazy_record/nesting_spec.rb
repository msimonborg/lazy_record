# frozen_string_literal: true

describe LazyRecord::Nesting do
  module One
    class NextToTwo; end
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
      expect(One::Two::Three.lazy_const_get('One').call). to be One
    end

    it 'can find Four' do
      expect(One::Two::Three.lazy_const_get('Four').call). to be One::Two::Four
    end

    it 'can find Five' do
      expect(One::Two::Three.lazy_const_get('Five').call). to be One::Two::Five
    end

    it 'can find NextToTwo' do
      expect(One::Two::Three.lazy_const_get_one_level_back('NextToTwo').call). to be One::NextToTwo
    end
  end
end

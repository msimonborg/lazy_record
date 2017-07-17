# frozen_string_literal: true

describe LazyRecord::DynamicModules do
  extend LazyRecord::DynamicModules

  global_module = Object.const_set(:GlobalModule, 'Global Module')
  namespaced_module = const_set(:NamespacedModule, 'Namespaced Module')

  one = get_or_set_mod('NamespacedModule')
  two = get_or_set_mod('GlobalModule')

  context '.get_or_set_mod' do
    it 'finds namespaced constants that are already defined' do
      expect(one).to be namespaced_module
      expect(one).to be_a String
      expect(one).to eq 'Namespaced Module'
    end

    it 'creates a new namespaced module if the constant only exists outside of the current scope' do
      expect(two).not_to be global_module
      expect(two).to be_a Module
    end
  end
end

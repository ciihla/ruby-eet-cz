# frozen_string_literal: true
require 'spec_helper'

describe EET_CZ do
  it 'has a version number' do
    expect(EET_CZ::VERSION).not_to be nil
  end

  describe 'configure' do
    before do
      EET_CZ.configure do |config|
        config.dic_popl = 'CZ123456789'
        config.id_provoz = '12345'
      end
    end

    it 'returns correct data' do
      expect(EET_CZ.config.dic_popl).to eq('CZ123456789')
      expect(EET_CZ.config.id_provoz).to eq('12345')
    end
  end
end

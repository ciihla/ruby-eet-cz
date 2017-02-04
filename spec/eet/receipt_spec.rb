# frozen_string_literal: true
require 'spec_helper'

describe EET_CZ::Receipt do
  let(:receipt) { EET_CZ::Receipt.new }

  it 'returns instance' do
    expect(receipt).to be_an_instance_of(EET_CZ::Receipt)
  end

  it 'invalid' do
    expect(receipt).not_to be_valid
  end

  context 'validate' do
    let(:receipt) do
      EET_CZ::Receipt.new(dat_trzby:  Time.parse('2016-08-05T00:30:12+02:00'),
                          id_pokl:    '/5546/RO24',
                          porad_cis:  '0/6460/ZQ42',
                          celk_trzba: 34_113.899)
    end

    it 'valid' do
      expect(receipt).to be_valid
    end

    it 'celk_trzba' do
      expect(receipt.celk_trzba).to eq('34113.90')
    end
  end
end

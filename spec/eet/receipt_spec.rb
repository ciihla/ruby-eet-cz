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
      EET_CZ::Receipt.new(created_at:       Time.parse('2016-08-05T00:30:12+02:00'),
                          cash_register_id: '/5546/RO24',
                          receipt_number:   '0/6460/ZQ42',
                          total_price:      34_113.00)
    end

    it 'valid' do
      expect(receipt).to be_valid
    end
  end
end

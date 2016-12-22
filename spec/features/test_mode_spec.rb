# frozen_string_literal: true
require 'spec_helper'

describe 'test_mode' do
  let(:receipt) do
    EET_CZ::Receipt.new(created_at:       Time.parse('2016-08-05T00:30:12+02:00'),
                        cash_register_id: '/5546/RO24',
                        receipt_number:   '0/6460/ZQ42',
                        total_price:      34_113.00)
  end

  let(:request) { EET_CZ::Request.new(receipt) }

  def do_request(cassette)
    VCR.use_cassette cassette do
      request.run
    end
  end

  context 'test mode' do
    before(:each) do
      EET_CZ.configure do |config|
        config.test_mode = true
      end
    end

    context 'play_ground' do
      before(:each) do
        EET_CZ.configure do |config|
          config.endpoint = EET_CZ::PG_EET_URL
        end
      end

      context 'valid request' do
        it 'success' do
          response = do_request('trzba/test_mode/play_ground/valid')
          expect(response).to be_success
          expect(response).to be_test
        end
      end

      context 'invalid request' do
        before(:each) do
          EET_CZ.configure do |config|
            config.vat = 'xxx'
          end
        end

        it 'invalid' do
          response = do_request('trzba/test_mode/play_ground/invalid')
          expect(response).not_to be_success
          expect(response).to be_test
        end
      end
    end

    context 'production' do
      before(:each) do
        EET_CZ.configure do |config|
          config.endpoint = EET_CZ::PROD_EET_URL
        end
      end

      xcontext 'valid request' do
        it 'valid request' do
          response = do_request('trzba/test_mode/production/valid')
          expect(response).to be_success
          expect(response).not_to be_test
        end
      end

      context 'invalid request' do
        before(:each) do
          EET_CZ.configure do |config|
            config.vat = 'xxx'
          end
        end

        it 'not valid' do
          response = do_request('trzba/test_mode/production/invalid')
          expect(response).not_to be_success
          expect(response).not_to be_test
        end
      end
    end
  end
end

# frozen_string_literal: true
require 'spec_helper'

describe 'overeni' do
  let(:receipt) do
    EET_CZ::Receipt.new(dat_trzby:  Time.parse('2016-08-05T00:30:12+02:00'),
                        id_pokl:    '/5546/RO24',
                        porad_cis:  '0/6460/ZQ42',
                        celk_trzba: 34_113.00)
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
        config.overeni = true
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
          expect(response).to be_an_instance_of(EET_CZ::Response::Error)
          expect(response.kod).to eq(0)
          expect(response.dat_odmit).to be_present
          expect(response).to be_success
          expect(response).to be_test
        end
      end

      context 'invalid request' do
        before(:each) do
          EET_CZ.configure do |config|
            config.dic_popl = 'xxx'
          end
        end

        it 'invalid' do
          response = do_request('trzba/test_mode/play_ground/invalid')
          expect(response).to be_an_instance_of(EET_CZ::Response::Error)
          expect(response.kod).to eq(3)
          expect(response.dat_odmit).to be_present
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

      xcontext 'valid request' do # Due to a valid SSL certificate
        it 'valid request' do
          response = do_request('trzba/test_mode/production/valid')
          expect(response).to be_an_instance_of(EET_CZ::Response::Error)
          expect(response.kod).to eq(0)
          expect(response.dat_odmit).to be_present
          expect(response).to be_success
          expect(response).not_to be_test
        end
      end

      context 'invalid request' do
        before(:each) do
          EET_CZ.configure do |config|
            config.dic_popl = 'xxx'
          end
        end

        it 'not valid' do
          response = do_request('trzba/test_mode/production/invalid')
          expect(response).to be_an_instance_of(EET_CZ::Response::Error)
          expect(response.kod).to eq(3)
          expect(response.dat_odmit).to be_present
          expect(response).not_to be_success
          expect(response).not_to be_test
        end
      end
    end
  end
end

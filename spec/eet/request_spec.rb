# frozen_string_literal: true
require 'spec_helper'

describe EET_CZ::Request do
  let(:receipt) do
    EET_CZ::Receipt.new(dat_trzby:       Time.parse('2016-08-05T00:30:12+02:00'),
                        id_pokl: '/5546/RO24',
                        porad_cis:   '0/6460/ZQ42',
                        celk_trzba:      34_113.00)
  end

  let(:request) { EET_CZ::Request.new(receipt) }

  let(:test_pem_pkp) do
    %(JvCv0lXfT74zuviJaHeO91guUfum1MKhq0NNPxW0YlBGvIIt+I4QxEC3QP6BRwEkIS14n2WN+9oQ8nhQPYwZX7L4W9Ie7CYv1ojcl/
YiF4560EdB3IpRNRj3UjQlwSZ5ucSM9vWqp0UTbhJDSUk5/WjC/CEiSYv7OQIqa0NJ0f0+ldzGveLRSF34eu2iqAhs/yfDnENlnMDPVB5ko/
zQO0vcC93k5DEWEoytTIAsKd6jKSO7eama8Qe+d0wq9vBzudkfLgCe2C1iERJuyHknhjo9KOx10h5wk99QqVGX8tthpAmryDcX2N0ZGkzJHuzzebnYsxXFYI2tKOJLiLLoLQ==).gsub(/\s/, '').strip
  end

  let(:test_p12_pkp) do
    %(hlDZ+XY0Mct2BibywpfoRw+RQZwmgl/SpQhmBBbKEYYZko6B71XiPevvKFNZuqkQb3kwvn3QSqKGe2mxm6Q0PtexfOWuNRoThH/PVI8SyVqRg4EcHi37
/2VQxF/QJG+JH/BFHdSxE2ROSvG/GEHDIpmHhBRkCoY+9723UTjyx0vXr4FhNODbPWrhjeM/sCoLEi5HT2dAsI2wIg4QE9K1o+
szSOdqlAdkey7M6m12AQW0LkBSPqPUi3NWa+Flo9xAPRyEKA49EQpndngu+kgPncElIfczSyhWOdQVq3D9FSwRD1ZXaY7tvyYgWLmNNF3xNn3ahCN0Hu41+wMPsqLGQw==).gsub(/\s/, '').strip
  end

  before(:each) do
    EET_CZ.configure do |config|
      config.dic_popl = 'CZ1212121218'
      config.id_provoz = '273'
    end
  end

  it 'returns instance' do
    expect(request).to be_an_instance_of(EET_CZ::Request)
  end

  context 'p12 key' do
    before(:each) do
      EET_CZ.configure do |config|
        config.ssl_cert_key_file = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
        config.ssl_cert_key_password = 'eet'
      end
    end

    describe 'pkp' do
      it 'valid' do
        expect(request.pkp).to eq(test_p12_pkp)
      end
    end

    describe 'bkp' do
      it 'valid' do
        expect(request.bkp(test_pem_pkp)).to eq('3F9119C1-FBF34535-D30B60F8-9859E4A6-C8C8AAFA')
      end
    end
  end

  context 'pem key' do
    describe 'pkp' do
      it 'valid' do
        expect(request.pkp).to eq(test_pem_pkp)
      end
    end
  end

  context 'client' do
    let(:client) { request.client }

    it 'returns instance' do
      expect(client).to be_an_instance_of(Savon::Client)
    end
  end
end

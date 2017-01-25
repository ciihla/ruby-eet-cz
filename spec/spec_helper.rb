# frozen_string_literal: true
require 'vcr'
require 'webmock'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'eet_cz'

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include CertFixturePath

  config.before(:each) do
    EET_CZ.configure do |c|
      c.endpoint              = EET_CZ::PG_EET_URL
      c.ssl_cert_file         = cert_fixture_path('certificate.pem')
      c.ssl_cert_key_file     = cert_fixture_path('private_key.pem')
      c.ssl_cert_key_password = nil
      c.overeni               = true # Use only test mode! It sends overeni='true'
      c.debug_logger          = false
      c.dic_popl              = 'CZ1212121218'
      c.id_provoz             = '273'
      c.rezim                 = '0'
    end
  end
end

VCR.configure do |config|
  config.cassette_library_dir                    = 'spec/support/cassettes'
  config.allow_http_connections_when_no_cassette = false
  config.hook_into :webmock
end

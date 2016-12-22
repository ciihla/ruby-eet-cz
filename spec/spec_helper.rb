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
      c.test_mode             = true # Use only test mode! It sends overeni='true'
      c.debug                 = false
      c.vat                   = 'CZ1212121218'
      c.premisses_id          = '273'
      c.eet_mode              = '0'
      # c.debug_logger          = Logger.new($stdout)
    end
  end
end

VCR.configure do |config|
  config.cassette_library_dir                    = 'spec/support/cassettes'
  config.allow_http_connections_when_no_cassette = false
  config.hook_into :webmock
end

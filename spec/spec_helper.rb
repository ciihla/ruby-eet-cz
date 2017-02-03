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
      c.ssl_cert_file         = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
      c.ssl_cert_key_file     = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
      c.ssl_cert_key_password = 'eet'
      c.overeni               = true # Use only test mode! It sends overeni='true'
      c.debug_logger          = false
      c.dic_popl              = 'CZ00000019'
      c.id_provoz             = '273'
      c.rezim                 = '0' # 0 - bezny rezim, 1 - zjednoduseny rezim
    end
  end
end

VCR.configure do |config|
  config.default_cassette_options                = { match_requests_on: [:method, :uri, :headers] }
  config.cassette_library_dir                    = 'spec/support/cassettes'
  config.allow_http_connections_when_no_cassette = false
  config.hook_into :webmock
end

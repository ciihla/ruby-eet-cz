# frozen_string_literal: true
require 'vcr'
require 'webmock'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'eet_cz'

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include CertFixturePath
  config.include SharedContext
end

VCR.configure do |config|
  config.default_cassette_options                = { match_requests_on: [:method, :uri, :headers] }
  config.cassette_library_dir                    = 'spec/support/cassettes'
  config.allow_http_connections_when_no_cassette = false
  config.hook_into :webmock
end

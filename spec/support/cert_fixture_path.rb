# frozen_string_literal: true
module CertFixturePath
  def cert_fixture_path(cert)
    "./spec/fixtures/cert/#{cert}"
  end
end

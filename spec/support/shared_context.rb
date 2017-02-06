# frozen_string_literal: true
module SharedContext
  extend RSpec::SharedContext

  let(:client) do
    EET_CZ::Client.new.tap do |c|
      c.ssl_cert_file         = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
      c.ssl_cert_key_file     = cert_fixture_path('EET_CA1_Playground-CZ00000019.p12')
      c.ssl_cert_key_password = 'eet'
      c.overovaci_mod         = true # Use only test mode! It sends overeni='true'
      c.debug_logger          = false
      c.dic_popl              = 'CZ1212121218'
      c.id_provoz             = '273'
      c.zjednoduseny_rezim    = false # false - bezny rezim, true - zjednoduseny rezim
    end
  end
end

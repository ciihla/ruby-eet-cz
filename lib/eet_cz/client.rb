# frozen_string_literal: true
module EET_CZ
  class Client
    def self.init
      new.client
    end

    def client
      Savon.client(options) do
        wsse_signature Akami::WSSE::Signature.new(Akami::WSSE::Certs.new(cert_file:            EET_CZ.config.ssl_cert_file,
                                                                         private_key_file:     EET_CZ.config.ssl_cert_key_file,
                                                                         private_key_password: EET_CZ.config.ssl_cert_key_password),
                                                  digest: 'sha256')
      end
    end

    def options
      options = {
        endpoint:             EET_CZ.config.endpoint,
        namespace:            'http://fs.mfcr.cz/eet/schema/v3',
        encoding:             'UTF-8',
        namespace_identifier: :eet
      }

      if EET_CZ.config.debug_logger
        options[:log_level]        = :debug
        options[:log]              = true
        options[:pretty_print_xml] = true
        options[:logger]           = EET_CZ.config.debug_logger
      end

      options
    end
  end
end

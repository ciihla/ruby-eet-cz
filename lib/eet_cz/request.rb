# frozen_string_literal: true
module EET_CZ
  class Request
    attr_reader :receipt, :client

    def initialize(receipt)
      raise('certificate not found') if EET_CZ.config.ssl_cert_file.blank?
      raise('ssh key not found') if EET_CZ.config.ssl_cert_key_file.blank?
      @receipt = receipt
      @client  = EET_CZ::Client.init
    end

    def run
      response = client.call('Trzba', soap_action: 'http://fs.mfcr.cz/eet/OdeslaniTrzby', message: [header, data, footer].reduce({}, :merge))
      EET_CZ::Response.new(response.doc)
      # TODO: error handling (Net::HTTP, etc..)
    end

    def header
      {
        'eet:Hlavicka' => {
          '@uuid_zpravy' => receipt.uuid, # RFC 4122
          '@dat_odesl'     => receipt.created_at, # ISO 8601
          '@prvni_zaslani' => true, # 1=first try; 0=retry # TODO configurable?
          '@overeni'       => EET_CZ.config.test_mode # 1=testing mode; 0=production mode!
        }
      }
    end

    def data
      {
        'eet:Data' => {
          '@dic_popl' => EET_CZ.config.vat,
          '@id_provoz'  => EET_CZ.config.premisses_id,
          '@id_pokl'    => receipt.cash_register_id,
          '@porad_cis'  => receipt.receipt_number,
          '@dat_trzby'  => receipt.created_at,
          '@celk_trzba' => receipt.total_price,
          '@rezim'      => EET_CZ.config.eet_mode || '0'
        }
      }
    end

    def footer
      {
        'eet:KontrolniKody' => {
          'eet:pkp' => {
            '@digest' => 'SHA256',
            '@cipher'   => 'RSA2048',
            '@encoding' => 'base64',
            :content!   => pkp
          },
          'eet:bkp' => {
            '@digest'   => 'SHA1',
            '@encoding' => 'base16',
            :content!   => bkp
          }
        }
      }
    end

    # @return base64 signed text from plain_text.
    # plain_text consists of:
    # DIC|ID_PROVOZ|ID_POKL|PORAD_CISL|DATUM|CENA
    # i.e: "CZ72080043|181|00/2535/CN58|0/2482/IE25|2016-12-07T22:01:00+01:00|87988.00"
    def pkp
      Base64.strict_encode64(private_key.sign(OpenSSL::Digest::SHA256.new, plain_text))
    end

    def bkp(base64_pkp = pkp)
      Digest::SHA1.hexdigest(Base64.strict_decode64(base64_pkp)).upcase.scan(/.{8}/).join('-')
    end

    private

    def plain_text
      [EET_CZ.config.vat,
       EET_CZ.config.premisses_id,
       receipt.cash_register_id,
       receipt.receipt_number,
       receipt.created_at,
       receipt.total_price].join('|')
    end

    def private_key
      case cert_key_type
      when 'p12'
        OpenSSL::PKCS12.new(File.read(EET_CZ.config.ssl_cert_key_file), EET_CZ.config.ssl_cert_key_password).key
      when 'pem'
        OpenSSL::PKey::RSA.new(File.read(EET_CZ.config.ssl_cert_key_file), EET_CZ.config.ssl_cert_key_password)
      end
    end

    def cert_key_type
      EET_CZ.config.ssl_cert_key_file.split('.').last || 'p12'
    end
  end
end

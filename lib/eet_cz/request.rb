# frozen_string_literal: true
module EET_CZ
  class Request
    attr_reader :receipt, :client, :options

    # options:
    # @prvni_zaslani: true=first try; false=retry
    def initialize(receipt, options = {})
      raise('certificate not found') if EET_CZ.config.ssl_cert_file.blank?
      @receipt = receipt
      @options = options
      @client  = EET_CZ::Client.instance
    end

    def run
      response = client.call('Trzba', soap_action: 'http://fs.mfcr.cz/eet/OdeslaniTrzby', message: [header, data, footer].reduce({}, :merge))
      EET_CZ::Response::Base.parse(response.doc)
      # TODO: error handling (Net::HTTP, etc..)
    end

    def header
      {
        'eet:Hlavicka' => {
          '@uuid_zpravy' => receipt.uuid_zpravy, # RFC 4122
          '@dat_odesl'     => receipt.dat_trzby, # ISO 8601
          '@prvni_zaslani' => prvni_zaslani, # true=first try; false=retry
          '@overeni'       => overeni # true=testing mode; false=production mode!
        }
      }
    end

    def data
      {
        'eet:Data' => {
          '@dic_popl' => EET_CZ.config.dic_popl,
          '@id_provoz'  => id_provoz,
          '@id_pokl'    => receipt.id_pokl,
          '@porad_cis'  => receipt.porad_cis,
          '@dat_trzby'  => receipt.dat_trzby,
          '@celk_trzba' => receipt.celk_trzba,
          '@rezim'      => EET_CZ.config.rezim || '0' # 0 - bezny rezim, 1 - zjednoduseny rezim
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

    # Digest from pkp
    # i.e: '03ec1d0e-6d9f77fb-1d798ccb-f4739666-a4069bc3'
    def bkp(base64_pkp = pkp)
      Digest::SHA1.hexdigest(Base64.strict_decode64(base64_pkp)).upcase.scan(/.{8}/).join('-')
    end

    private

    def plain_text
      [EET_CZ.config.dic_popl,
       id_provoz,
       receipt.id_pokl,
       receipt.porad_cis,
       receipt.dat_trzby,
       receipt.celk_trzba].join('|')
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

    def id_provoz
      options[:id_provoz] || EET_CZ.config.id_provoz
    end

    def prvni_zaslani
      options[:prvni_zaslani] || true
    end

    def overeni
      EET_CZ.config.overeni == false ? false : EET_CZ.config.overeni || true
    end
  end
end

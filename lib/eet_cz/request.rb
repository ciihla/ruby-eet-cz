# frozen_string_literal: true
module EET_CZ
  class Request
    include EET_CZ::Concerns::TrueValue
    include EET_CZ::Concerns::TestMode
    attr_reader :receipt, :client, :options

    # options:
    # @prvni_zaslani: true=first try; false=retry
    def initialize(client, receipt, options = {})
      @receipt = receipt
      @options = options
      @client  = client
    end

    def run
      return EET_CZ::Response::Fake.new if self.class.fake?
      response = client.service.call('Trzba', soap_action: 'http://fs.mfcr.cz/eet/OdeslaniTrzby', message: message)
      EET_CZ::Response::Base.parse(response.doc)
      # TODO: error handling (Net::HTTP, etc..)
    end

    def message
      [header, data, footer].reduce({}, :merge)
    end

    def header
      {
        'eet:Hlavicka' => {
          '@uuid_zpravy' => uuid_zpravy, # RFC 4122
          '@dat_odesl'     => dat_odesl, # ISO 8601
          '@prvni_zaslani' => prvni_zaslani, # true=first try; false=retry
          '@overeni'       => overeni # true=testing mode; false=production mode!
        }
      }
    end

    def data
      inner = {
        '@dic_popl' => client.dic_popl,
        '@id_provoz' => id_provoz,
        '@rezim'     => rezim
      }

      receipt.used_attrs.keys.each do |a|
        value          = receipt.send(a)
        inner["@#{a}"] = value unless value.nil?
      end

      { 'eet:Data' => inner }
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

    def rezim
      options[:rezim] || client.zjednoduseny_rezim && '1' || '0' # 0 - bezny rezim, 1 - zjednoduseny rezim
    end

    private

    def uuid_zpravy
      @uuid_zpravy ||= SecureRandom.uuid
    end

    def dat_odesl
      @dat_odesl ||= Time.current.iso8601
    end

    def plain_text
      [client.dic_popl,
       id_provoz,
       id_pokl,
       receipt.porad_cis,
       receipt.dat_trzby,
       receipt.celk_trzba].join('|')
    end

    def private_key
      client.certs.private_key
    end

    def id_provoz
      options[:id_provoz] || client.id_provoz
    end

    def prvni_zaslani
      true_value?(options[:prvni_zaslani])
    end

    def overeni
      true_value?(client.overovaci_mod)
    end

    def id_pokl
      options[:id_pokl] || receipt.id_pokl
    end
  end
end

# frozen_string_literal: true
module EET_CZ
  class Client
    DEFAULT_CERT_TYPE = 'p12'.freeze

    attr_accessor :endpoint, :overovaci_mod, :debug_logger, :dic_popl, :id_provoz, :zjednoduseny_rezim, :ssl_cert_key_password,
                  :ssl_cert_type, :ssl_cert_file, :ssl_cert_string, :ssl_cert_key_type, :ssl_cert_key_file, :ssl_cert_key_string

    def initialize(options = {})
      options.each do |key, value|
        send :"#{key}=", value
      end

      @endpoint ||= EET_CZ::PG_EET_URL
      set_default_cert_types
    end

    def service
      @service ||= Savon.client(options) do |service|
        service.wsse_signature Akami::WSSE::Signature.new(certs, digest: 'sha256')
      end
    end

    def certs
      return @certs if @certs

      @certs                      = Akami::WSSE::Certs.new
      @certs.cert_type            = ssl_cert_type
      @certs.cert_string          = ssl_cert_string
      @certs.private_key_type     = ssl_cert_key_type
      @certs.private_key_string   = ssl_cert_key_string
      @certs.private_key_password = ssl_cert_key_password
      raise('certificate not found') unless @certs.cert_string

      @certs
    end

    def options
      options = {
        endpoint:             endpoint,
        namespace:            'http://fs.mfcr.cz/eet/schema/v3',
        encoding:             'UTF-8',
        namespace_identifier: :eet
      }

      if debug_logger
        options[:log_level]        = :debug
        options[:log]              = true
        options[:pretty_print_xml] = true
        options[:logger]           = debug_logger
      end

      options
    end

    def build_receipt(attributes = {})
      EET_CZ::Receipt.new(attributes)
    end

    def build_request(receipt, options = {})
      EET_CZ::Request.new(self, receipt, options)
    end

    def ssl_cert_key_string
      @ssl_cert_key_string ||= File.read(ssl_cert_key_file)
    end

    def ssl_cert_string
      @ssl_cert_string ||= File.read(ssl_cert_file)
    end

    def set_default_cert_types
      @ssl_cert_type = File.extname(ssl_cert_file) if ssl_cert_file
      @ssl_cert_key_type = File.extname(ssl_cert_key_file) if ssl_cert_key_file

      @ssl_cert_type     ||= DEFAULT_CERT_TYPE
      @ssl_cert_key_type ||= DEFAULT_CERT_TYPE
    end
  end
end

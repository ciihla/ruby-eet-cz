# frozen_string_literal: true
module Akami
  class WSSE
    class Certs
      def cert
        @cert ||= case File.extname(cert_file)
                  when '.p12'
                    OpenSSL::PKCS12.new(File.read(cert_file), private_key_password).certificate
                  else
                    OpenSSL::X509::Certificate.new File.read(cert_file)
                  end if cert_file
      end

      # Returns an <tt>OpenSSL::PKey::RSA</tt> for the +private_key_file+.
      def private_key
        @private_key ||= case File.extname(private_key_file)
                         when '.p12'
                           OpenSSL::PKCS12.new(File.read(private_key_file), private_key_password).key
                         else
                           OpenSSL::PKey::RSA.new(File.read(private_key_file), private_key_password)
                         end if private_key_file
      end
    end

    class Signature
      # For a +Savon::WSSE::Certs+ object. To hold the certs we need to sign.
      attr_accessor :certs, :digest

      SHA256DigestAlgorithm       = 'http://www.w3.org/2001/04/xmlenc#sha256'
      RSASHA256SignatureAlgorithm = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'

      def initialize(certs = Certs.new, options = {})
        @certs  = certs
        @digest = (options[:digest] || 'sha1').upcase
      end

      private

      def signed_info
        {
            'SignedInfo' => {
                'CanonicalizationMethod/' => nil,
                'SignatureMethod/'        => nil,
                'Reference'               => [
                    signed_info_transforms.merge(signed_info_digest_method).merge('DigestValue' => body_digest)
                ],
                :attributes!              => {
                    'CanonicalizationMethod/' => { 'Algorithm' => ExclusiveXMLCanonicalizationAlgorithm },
                    'SignatureMethod/'        => { 'Algorithm' => Signature.const_get("RSA#{digest}SignatureAlgorithm") },
                    'Reference'               => { 'URI' => ["##{body_id}"] }
                },
                :order!                   => ['CanonicalizationMethod/', 'SignatureMethod/', 'Reference']
            }
        }
      end

      def the_signature
        raise MissingCertificate, 'Expected a private_key for signing' unless certs.private_key
        signed_info = at_xpath(@document, '//Envelope/Header/Security/Signature/SignedInfo')
        signed_info = signed_info ? canonicalize(signed_info) : ''
        signature   = certs.private_key.sign(digest_class.new, signed_info)
        Base64.encode64(signature).delete("\n") # TODO: DRY calls to Base64.encode64(...).gsub("\n", '')
      end

      def body_digest
        body = canonicalize(at_xpath(@document, '//Envelope/Body'))
        Base64.encode64(digest_class.digest(body)).strip
      end

      def signed_info_digest_method
        { 'DigestMethod/' => nil, :attributes! => { 'DigestMethod/' => { 'Algorithm' => Signature.const_get("#{digest}DigestAlgorithm") } } }
      end

      def uid
        digest_class.hexdigest([Time.now, rand].collect(&:to_s).join('/'))
      end

      def digest_class
        @digest_class ||= "OpenSSL::Digest::#{digest}".constantize
      end
    end
  end
end

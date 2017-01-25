# frozen_string_literal: true
require 'spec_helper'

describe EET_CZ::Response do
  let(:response) { EET_CZ::Response.new(Nokogiri::XML(xml)) }

  context 'fault' do
    let(:xml) do
      '<soapenv:Envelope xmlns:eet="http://fs.mfcr.cz/eet/schema/v3"
    xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
    xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
    xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
     xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Header/>
  <soapenv:Body>
    <eet:Odpoved>
      <eet:Hlavicka uuid_zpravy="a8c040bf-99c6-446c-b1e8-7702ce31530d" dat_odmit="2016-12-19T08:46:41+01:00"/>
      <eet:Chyba kod="4" test="true">Neplatny podpis SOAP zpravy</eet:Chyba>
    </eet:Odpoved>
  </soapenv:Body>
</soapenv:Envelope>'
    end

    it 'returns instance' do
      expect(response).to be_an_instance_of(EET_CZ::Response)
      expect(response).not_to be_success
    end

    it 'returns error' do
      error = response.error
      expect(error.attributes['kod'].value).to eq('4')
      expect(error.attributes['test'].value).to eq('true')
      expect(error.text).to eq('Neplatny podpis SOAP zpravy')
    end

    it 'returns header' do
      header = response.header
      expect(response.uuid_zpravy).to eq('a8c040bf-99c6-446c-b1e8-7702ce31530d')
      expect(response.dat_odmit).to eq('2016-12-19T08:46:41+01:00')
      expect(header.text).to eq('')
    end
  end

  context 'success' do
    let(:xml) do
      '<?xml version="1.0" encoding="UTF-8"?>
        <soapenv:Envelope xmlns:eet="http://fs.mfcr.cz/eet/schema/v3" xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"
xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
<soapenv:Header><wsse:Security soapenv:mustUnderstand="1">
<wsse:BinarySecurityToken wsu:Id="SecurityToken-65b228bd-513e-4dcd-912e-fc5d42b1dde7"
 EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary"
ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3">
MIIFsjCCBJqgAwIBAgIEAKn9EDANBgkqhkiG9w0BAQsFADCBtzELMAkGA1UEBhMCQ1oxOjA4BgNVBAMMMUkuQ0EgLSBRdWFsaWZpZWQgQ2VydGl
maWNhdGlvbiBBdXRob3JpdHksIDA5LzIwMDkxLTArBgNVBAoMJFBydm7DrSBjZXJ0aWZpa2HEjW7DrSBhdXRvcml0YSwgYS5zLjE9MDsGA
1UECww0SS5DQSAtIEFjY3JlZGl0ZWQgUHJvdmlkZXIgb2YgQ2VydGlmaWNhdGlvbiBTZXJ2aWNlczAeFw0xNjA2MDgwNTU0NTJaFw0xNzA2M
DgwNTU0NTJaMIGeMQswCQYDVQQGEwJDWjEzMDEGA1UEAwwqRWxla3Ryb25pY2vDoSBldmlkZW5jZS</wsse:BinarySecurityToken>
<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
        <SignedInfo>
          <CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
          <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
          <Reference URI="#Body-50bc2dc7-441a-4013-9f39-70f437f5408a">
            <Transforms>
              <Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
            </Transforms>
            <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
            <DigestValue>ROxm3M5kHDmROGyjWpihe2UnV6pa9JywpOW4T8jVW1I=</DigestValue>
          </Reference>
        </SignedInfo>
<SignatureValue>N3xjla0JvW7GJGdHUecEQHYPas7LTV29IPKVV2CIVBXGcW42iqiheL3UNhwMpKxjCTDIz/jf+NzzKC2eJTPqgPeIQYb7tGkJ5/
+Up8dyJCMR+IIu4cpoEuRrpfmOMEWN5Z+SSm1Z88CT3xbMqlWeX01oaa/B2M74GnFnxsriqBPrc3Ovwrv2gDuaZHsEz3rqks5FqtPHaWGcM1732lv1Bsy9oBh/tKKLSwH//
lVxOECR6qPJ9gfOgPrOCz0opDprZ8bYPKbKFjsvwMCLAxZOD2vxdKM/lOs57gSrshfNPdldKMieZCyBSXWwuQz4SqoRALOm/yv4gVAHznl21+t9Hg==</SignatureValue>
<KeyInfo><wsse:SecurityTokenReference xmlns="">
<wsse:Reference URI="#SecurityToken-65b228bd-513e-4dcd-912e-fc5d42b1dde7"
ValueType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3"/></wsse:SecurityTokenReference></KeyInfo>
</Signature></wsse:Security></soapenv:Header><soapenv:Body wsu:Id="Body-50bc2dc7-441a-4013-9f39-70f437f5408a">
<eet:Odpoved><eet:Hlavicka uuid_zpravy="3d2e888f-25a9-462f-9f1d-554fe7e9551d" bkp="3F9119C1-FBF34535-D30B60F8-9859E4A6-C8C8AAFA" dat_prij="2016-12-19T12:14:02+01:00"/>
<eet:Potvrzeni fik="fbfef3cf-ab44-4e5b-b1f5-16eccc2d9485-ff" test="true"/></eet:Odpoved></soapenv:Body></soapenv:Envelope>
'
    end

    it 'returns instance' do
      expect(response).to be_an_instance_of(EET_CZ::Response)
      expect(response).to be_success
    end

    it 'returns fik' do
      expect(response.fik).to eq('fbfef3cf-ab44-4e5b-b1f5-16eccc2d9485-ff')
      expect(response.dat_prij).to eq('2016-12-19T12:14:02+01:00')
      expect(response.test?).to eq(true)
    end

    it 'returns header' do
      expect(response.uuid_zpravy).to eq('3d2e888f-25a9-462f-9f1d-554fe7e9551d')
      expect(response.bkp).to eq('3F9119C1-FBF34535-D30B60F8-9859E4A6-C8C8AAFA')
    end
  end
end

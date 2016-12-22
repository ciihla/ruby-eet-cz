# frozen_string_literal: true
module EET_CZ
  class Response
    attr_reader :fik, :error, :header, :test, :uuid, :confirmed_at, :rejected_at, :bkp, :warnings

    def initialize(response)
      response.remove_namespaces!
      result = response.at('Odpoved')

      @header   = result.at('Hlavicka')
      @error    = result.at('Chyba')
      @confirm  = result.at('Potvrzeni')
      @warnings = result.search('Varovani') # TODO: implement logic

      parse_data
    end

    def parse_data
      parse_header

      if @confirm
        @fik  = @confirm.attributes['fik'].try(:value)
        @test = @confirm.attributes['test'].try(:value)
      end

      @test = @error.attributes['test'].try(:value) if @error
    end

    def parse_header
      @uuid         = header_attribute('uuid_zpravy')
      @confirmed_at = header_attribute('dat_prij')
      @rejected_at  = header_attribute('dat_odmit')
      @bkp          = header_attribute('bkp')
    end

    def success?
      error.nil? || error.attributes['kod'].value.to_i.zero?
    end

    def test?
      test.present?
    end

    private

    def header_attribute(attr)
      @header.attributes[attr].try(:value)
    end
  end
end

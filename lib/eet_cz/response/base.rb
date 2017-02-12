# frozen_string_literal: true
module EET_CZ
  module Response
    class Base
      attr_reader :doc, :uuid_zpravy, :bkp, :warnings, :fik

      def initialize(doc)
        @doc = doc
        parse_warnings
        parse_header
        parse_data
      end

      def self.parse(response)
        response.remove_namespaces!
        doc = response.at('Odpoved')

        if doc.at('Potvrzeni')
          EET_CZ::Response::Success.new(doc)
        else
          EET_CZ::Response::Error.new(doc)
        end
      end

      def success?
        raise('implement')
      end

      # If request was sent to Playground Endpoint
      def test?
        @test.present?
      end

      private

      def parse_data
        raise('implement')
      end

      def parse_header
        @uuid_zpravy = header_attribute('uuid_zpravy')
        @bkp         = header_attribute('bkp')
      end

      def parse_warnings
        @warnings = []
        doc.search('Varovani').each do |warning|
          @warnings << EET_CZ::Response::Warning.new(warning)
        end
      end

      def header_attribute(attr)
        doc.at('Hlavicka').attributes[attr].try(:value)
      end
    end
  end
end

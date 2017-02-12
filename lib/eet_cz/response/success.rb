# frozen_string_literal: true
module EET_CZ
  module Response
    class Success < Base
      attr_reader :dat_prij

      def success?
        true
      end

      private

      def parse_data
        @fik      = inner_doc.attributes['fik'].try(:value)
        @test     = inner_doc.attributes['test'].try(:value)
        @dat_prij = header_attribute('dat_prij')
      end

      def inner_doc
        @inner_doc ||= doc.at('Potvrzeni')
      end
    end
  end
end

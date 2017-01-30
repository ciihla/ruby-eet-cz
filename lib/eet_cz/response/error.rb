# frozen_string_literal: true
module EET_CZ
  module Response
    class Error < Base
      attr_reader :dat_odmit, :kod, :error

      def success?
        test? && kod.zero?
      end

      private

      def parse_data
        @test      = inner_doc.attributes['test'].try(:value)
        @kod       = inner_doc.attributes['kod'].try(:value).try(:to_i)
        @error     = inner_doc.text
        @dat_odmit = header_attribute('dat_odmit')
      end

      def inner_doc
        @inner_doc ||= doc.at('Chyba')
      end
    end
  end
end

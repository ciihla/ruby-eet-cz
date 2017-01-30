# frozen_string_literal: true
module EET_CZ
  module Response
    class Warning
      attr_reader :kod, :text

      def initialize(result)
        @kod  = result.attributes['kod_varov'].try(:value).try(:to_i)
        @text = result.text.squish
      end
    end
  end
end

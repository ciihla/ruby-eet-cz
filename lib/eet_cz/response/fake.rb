# frozen_string_literal: true
module EET_CZ
  module Response
    class Fake < Base
      def initialize; end

      def success?
        true
      end
    end
  end
end

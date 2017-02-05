# frozen_string_literal: true
module EET_CZ
  module Concerns
    module TrueValue
      extend ActiveSupport::Concern
      FALSE_VALUES = [false, 0, '0', 'false'].freeze

      def true_value?(attr)
        FALSE_VALUES.exclude?(attr)
      end
    end
  end
end

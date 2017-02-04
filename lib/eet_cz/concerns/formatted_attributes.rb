# frozen_string_literal: true
module EET_CZ
  module Concerns
    module FormattedAttributes
      extend ActiveSupport::Concern

      module ClassMethods
        def formatted(attr, proc)
          define_method(attr) do
            val = used_attrs[attr.to_sym]
            proc.call(val)
          end
        end
      end
    end
  end
end

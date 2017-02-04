# frozen_string_literal: true
module EET_CZ
  module Concerns
    module AvailableAttributes
      extend ActiveSupport::Concern

      included do
        attr_accessor :used_attrs
      end

      module ClassMethods
        attr_accessor :available_attrs

        def attrs_available(attrs)
          self.available_attrs = attrs
        end
      end

      def initialize(attributes = {})
        @used_attrs = attributes.symbolize_keys
      end

      def method_missing(method_sym, *arguments, &block)
        if self.class.available_attrs.include?(method_sym)
          used_attrs[method_sym]
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        self.class.available_attrs.include?(method_name) || super
      end
    end
  end
end

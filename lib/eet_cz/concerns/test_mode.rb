# frozen_string_literal: true
module EET_CZ
  module Concerns
    module TestMode
      extend ActiveSupport::Concern

      included do
        class << self
          attr_accessor :__test_mode

          def __set_test_mode(mode)
            if block_given?
              current_mode = __test_mode
              begin
                self.__test_mode = mode
                yield
              ensure
                self.__test_mode = current_mode
              end
            else
              self.__test_mode = mode
            end
          end

          def real!(&block)
            __set_test_mode(:real, &block)
          end

          def fake!(&block)
            __set_test_mode(:fake, &block)
          end

          def fake?
            __test_mode == :fake
          end
        end
      end
    end
  end
end

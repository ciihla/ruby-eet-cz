# frozen_string_literal: true
module EET_CZ
  class Receipt
    include ActiveModel::Validations

    VALID_FORMAT = %r(\A[0-9a-zA-Z\.,:;\/#\-_]{1,20}\z)

    # ID pokladny
    attr_reader :cash_register_id
    # ID dokladu/uctenky
    attr_reader :receipt_number

    validates :cash_register_id, presence: true, format: VALID_FORMAT
    validates :receipt_number, presence: true, format: VALID_FORMAT
    validates :created_at, presence: true
    validates :total_price, presence: true

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def total_price
      format('%.2f', @total_price.to_f)
    end

    def created_at
      (@created_at || Time.current).iso8601
    end
  end
end

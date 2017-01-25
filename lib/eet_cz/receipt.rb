# frozen_string_literal: true
module EET_CZ
  class Receipt
    include ActiveModel::Validations

    VALID_FORMAT = %r(\A[0-9a-zA-Z\.,:;\/#\-_]{1,20}\z)

    # ID pokladny
    attr_reader :id_pokl
    # ID dokladu/uctenky
    attr_reader :porad_cis

    validates :id_pokl, presence: true, format: VALID_FORMAT
    validates :porad_cis, presence: true, format: VALID_FORMAT
    validates :dat_trzby, presence: true
    validates :celk_trzba, presence: true

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def uuid_zpravy
      @uuid_zpravy ||= SecureRandom.uuid
    end

    def celk_trzba
      format('%.2f', @celk_trzba.to_f)
    end

    def dat_trzby
      (@dat_trzby || Time.current).iso8601
    end
  end
end

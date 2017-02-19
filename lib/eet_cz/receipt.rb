# frozen_string_literal: true
module EET_CZ
  class Receipt
    include ActiveModel::Validations
    include EET_CZ::Concerns::AvailableAttributes

    VALID_FORMAT = %r(\A[0-9a-zA-Z\.,:;\/#\-_]{1,20}\z)

    attrs_available %i(id_pokl porad_cis dat_trzby celk_trzba zakl_nepodl_dph zakl_dan1 dan1 zakl_dan2 dan2
                       zakl_dan3 dan3 cest_sluz pouzit_zboz1 pouzit_zboz2 pouzit_zboz3 urceno_cerp_zuct cerp_zuct).freeze

    validates :id_pokl, presence: true, format: VALID_FORMAT # ID pokladny
    validates :porad_cis, presence: true, format: VALID_FORMAT # ID dokladu/uctenky
    validates :dat_trzby, presence: true
    validates :celk_trzba, presence: true

    formatted :dat_trzby, ->(val) { val.iso8601 }

    %i(celk_trzba zakl_nepodl_dph zakl_dan1 dan1 zakl_dan2 dan2 zakl_dan3 dan3 cest_sluz pouzit_zboz1 pouzit_zboz2 pouzit_zboz3 urceno_cerp_zuct cerp_zuct).each do |attr|
      formatted attr, ->(val) { format('%.2f', val.to_f) }
    end
  end
end

# frozen_string_literal: true
require 'active_support/all'
require 'active_model'
require 'savon'

require 'eet_cz/concerns/available_attributes'
require 'eet_cz/concerns/formatted_attributes'
require 'eet_cz/version'
require 'eet_cz/receipt'
require 'eet_cz/request'
require 'eet_cz/response/base'
require 'eet_cz/response/error'
require 'eet_cz/response/success'
require 'eet_cz/response/warning'
require 'eet_cz/client'
require 'eet_cz/akami_patch'

module EET_CZ
  include ActiveSupport::Configurable
  # TODO: validation for config values?

  PG_EET_URL   = 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v3/'
  PROD_EET_URL = 'https://prod.eet.cz:443/eet/services/EETServiceSOAP/v3/'

  def self.working_dir
    Dir.pwd
  end
end

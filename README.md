# EET_CZ [![Build Status](https://travis-ci.org/ciihla/ruby-eet-cz.svg?branch=master)](https://travis-ci.org/ciihla/ruby-eet-cz)

EET wrapper for Ruby..

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-eet-cz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-eet-cz

## Usage

```ruby
require 'eet_cz'

EET_CZ.configure do |c|
  c.endpoint              = EET_CZ::PG_EET_URL # or EET_CZ::PROD_EET_URL
  c.ssl_cert_file         = path_to('EET_CA1_Playground-CZ00000019.p12') # or 'pem' supported
  c.ssl_cert_key_file     = path_to('EET_CA1_Playground-CZ00000019.p12') # or 'pem'
  c.ssl_cert_key_password = 'secret'
  c.overeni               = true # It sends attribute: overeni='true' Or explicitly specify 'false'
  c.debug_logger          = Logger.new('test.log') # or Logger.new($stdout) in tests?
  c.dic_popl              = 'CZ00000019' # dic_popl
  c.id_provoz             = '555' # id_provoz
  c.rezim                 = '0' # rezim
end

receipt = EET_CZ::Receipt.new(dat_trzby:  Time.zone.now,
                              id_pokl:    '/4432/D12',
                              porad_cis:  '4/541/FR34',
                              celk_trzba: 25.5)

request = EET_CZ::Request.new(receipt, prvni_zaslani: false) # default true
response = request.run

response.test?
response.success?
response.fik
response.bkp
response.uuid_zpravy
response.dat_prij
response.dat_odmit
response.error
response.warnings
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. 
Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Use `rubocop -a` to keep the code as clean as possible.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ciihla/ruby-eet-cz. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


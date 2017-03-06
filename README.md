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

client = EET_CZ::Client.new.tap do |c|
  c.endpoint              = EET_CZ::PG_EET_URL # or EET_CZ::PROD_EET_URL
  c.ssl_cert_file         = path_to('EET_CA1_Playground-CZ00000019.p12') # or 'pem' supported
  c.ssl_cert_key_file     = path_to('EET_CA1_Playground-CZ00000019.p12') # or 'pem'
  c.ssl_cert_key_password = 'eet'
  # OR specify:
  #  c.ssl_cert_type         = 'pem' # Defaults to extname from file or 'p12'
  #  c.ssl_cert_string       = 'certificate as String'
  #  c.ssl_cert_key_type     = 'pem' # Defaults to extname from file or 'p12'
  #  c.ssl_cert_key_string   = 'certificate as String'
  c.overovaci_mod         = true # It sends attribute: overeni='true' Or explicitly specify 'false'. `default: true`
  c.debug_logger          = Logger.new('log/eet.log') # or Logger.new($stdout) in tests?
  c.dic_popl              = 'CZ00000019' # dic_popl
  c.id_provoz             = '555' # id_provoz
  c.zjednoduseny_rezim    = false # `default: false`
end

receipt = client.build_receipt(dat_trzby:  Time.current,
                              id_pokl:    '/4432/D12',
                              porad_cis:  '4/541/FR34',
                              celk_trzba: 25.5,
                              zakl_nepodl_dph: '', # Optional
                              zakl_dan1: '', # Optional
                              dan1: '' # Optional
                              #... etc all possible Data attributes. See `EET_CZ::Receipt`
  )

request = client.build_request(receipt, prvni_zaslani: false) # default true
response = request.run

# For tests: EET_CZ::Request.fake! to disable EET call
# Or EET_CZ::Request.real! { example.run } # request will be sent!

puts JSON.pretty_generate(response.as_json)
```

Running the script above should print something like:

```JSON
{
  "doc": [

  ],
  "warnings": [

  ],
  "uuid_zpravy": "96041020-2996-406d-a90b-f967336ee738",
  "bkp": "A3DED039-31F4AB57-DDC741E5-8CA28070-624E149C",
  "inner_doc": [
    [
      "fik",
      "382fbe6d-fa67-413a-88d9-6048dc1bd4c0-ff"
    ],
    [
      "test",
      "true"
    ]
  ],
  "fik": "382fbe6d-fa67-413a-88d9-6048dc1bd4c0-ff",
  "test": "true",
  "dat_prij": "2017-03-04T19:01:26+01:00"
}
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

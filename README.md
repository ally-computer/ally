ally
====

Ally, is like a personal assistant. Its a natural language parsing framework to build your own and collaborative plugins to extend its capabilities. Think of it as a flexible, open sourced, [siri](http://www.apple.com/ios/siri/?cid=wwa-us-kwg-features-com). 

## Installation

Add this line to your application's Gemfile:

    gem 'ally'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ally

For each additional functionality you want to add to your ally, add it to the Gemfile.
Heres an example

```
source 'https://rubygems.org'

ruby '2.1.0'
#ruby-gemset=my-ally

# IO plugins
gem 'ally-io-console'

# Render Plugins
gem 'ally-render-hello'
```

Create your yaml config file, similar to this one.

```
me:
  name:
    first: 'Chad'
    last_name: 'Barraford'
  birthday:
    month: 8
    day: 20
    year: 1982
  contact:
    cell: 11235551234
    email: 'cbarraford@gmail.com'
  home:
    street: 'main street'
    number: 1
    city: 'Boston'
    state: 'MA'
    country: 'USA'
    zipcode: '01001'
renders:
  hello:
    keywords: # set additional keywords
      - ciao
detectors:
  place:
    apikey: 'XXXXXXXXXXXXXXXXXXXXXXX'
ios:
```

To start ally, run 

```bash
ally start -c <yaml config file>
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/ally/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

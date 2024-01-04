<img src="./logo/virtuous.svg" width="200" />

# Virtuous Ruby Client ![example workflow](https://github.com/taylorbrooks/virtuous/actions/workflows/test.yml/badge.svg)

A Ruby wrapper for the Virtuous API

To get a general overview of Virtuous: https://virtuous.org

[RDocs](https://rubydoc.info/github/taylorbrooks/virtuous/master)

### Installation

Add this line to your application's Gemfile:

```ruby
  # in your Gemfile
  gem 'virtuous', '~> 0.0.2'

  # then...
  bundle install
```

### Usage

```ruby
  # Authenticating with username and password
  client = Virtuous::Client.new
  client.authenticate(username: ..., password: ...)

  # Authenticating with api keys
  client = Virtuous::Client.new(api_key: ...)

  # Find a specific contact
  client.find_contact_by_email('gob@bluthco.com')
```

### History

View the [changelog](https://github.com/taylorbrooks/virtuous/blob/master/CHANGELOG.md)

This gem follows [Semantic Versioning](http://semver.org/)

### Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/taylorbrooks/virtuous/issues)
- Fix bugs and [submit pull requests](https://github.com/taylorbrooks/virtuous/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

### Copyright

Copyright (c) 2018 Taylor Brooks. See LICENSE for details.

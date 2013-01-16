# GhostWriter
[![Build Status](https://travis-ci.org/joker1007/ghost_writer.png)](https://travis-ci.org/joker1007/ghost\_writer)
Generate API examples from params and response of controller specs

## Installation

Add this line to your application's Gemfile:

    gem 'ghost_writer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ghost_writer

## Usage

Write controller spec:
```ruby
# spec\_helper
RSpec.configure do |config|
  config.include GhostWriter
end

# posts\_controller\_spec
require 'spec_helper'

describe PostsController do
  describe "GET index" do
    it "should be success", generate_api_doc: true do # Add metadata :generate_api_doc
      get :index
      response.should be_success
    end

    it "should be success", generate_api_doc: "index_error" do # if metadata value is string, use it as filename
      get :index
      response.status.should eq 404
    end
  end
end
```

And set environment variable GENERATE_API_DOC at runtime
```
GENERATE_API_DOC=1 bundle exec rspec spec
-> generate docs at [Rails.root]/doc/api_examples
```

If you don't set environment variable, this gem doesn't generate docs.

## TODO
- support more output formats (now markdown only)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

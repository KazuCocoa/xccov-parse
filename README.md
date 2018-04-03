# Xccov::Parse

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xccov-parse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xccov-parse

## Usage

1. Generate the json result by `xcrun xccov view --only-targets --json`
    ```
    $ xcrun xccov view --only-targets --json Build/Logs/Test/*.xccovreport > result.json
    ```
2. Read the JSON and get a particular line coverage
    ```ruby
    parsed = Xccov::Parse.new(file: './result.json')
    parsed.targets_line_coverage["test.examples.app"] #=> 0.35
    ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KazuCocoa/xccov-parse.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


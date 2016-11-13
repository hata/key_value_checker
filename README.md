# KeyValueChecker

`key_value_checker` is a simple tool to check key value map.
For example, a value for a key has a value rule like number only.
Then create a rule and run a script to validate it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'key_value_checker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install key_value_checker

## Usage

TODO: Write usage instructions here

Right now, `exe/key_value_checker` in the package can help to use it.

- Prepare a rule file.
```yaml
config:
 compare_set:
  separator: ','
rule_map:
 a:
  required: true
  pattern:
   - regex: '[0-9]+'
 b:
  required: false
  pattern:
   - equal: 1
 c:
  required: true
  pattern:
   - compare_set: '1,2,3'
```

Set key rule under rule_map. `a` is a key. And if the key is not a required parameter,
then set `required: false`, otherwise set `required: true`. `pattern` can accept several
rules. Right now, this tool can support, `equal`, `regex`, `compare_set`.

- `equal` is to compare a value is the same or not using a string.
- `regex` is to compare a value using regular expression. It is passed to Regexp.
- `compare_set` is to compare split values. If `1,2,3` is set, then compare key value data to check the value is match or not. This can help what value is not exist or not.
The separator is set in `config` values. Set like the above config.

Current support file format is like this:

```
a:123456
b:bar
c:2,3,4
```

Start a key text and then set a separator, `:`. After that, set values.

- Run script

After preparing rule and param file, then run like this:

```
exe/key_value_checker -c rule.yaml -f params.txt
```

Right now, parameter rules can override. So, you can set several rules.

```
exe/key_value_checker -c rule.yaml,override_rule.yaml -f params.txt
```

From this, set a global rule and then each file depend rule can set.

Example output information is like this.

```
SUC: Regexp([0-9]+) match. key='a' 123456
ERR: Equal not match key='b'. 1
ERR: Not Equal set key='c'. rule_values - param_values = [1], param_values - rule_values: [4]
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/key_value_checker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


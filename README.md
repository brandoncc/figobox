![Travis build status](https://travis-ci.org/brandoncc/figobox.svg?branch=master)

# Figobox

[Figaro](https://github.com/laserlemon/figaro) is an incredibly useful and popular tool in the Rails community. [Nanobox](https://nanobox.io/) is an up and coming app deployment platform that deploys dockerized app components to one or more VPS' on the provider of your choice. These are both great tools, so why shouldn't they work together?

This tool brings the convenience of the `figaro heroku:set` command to nanobox.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'figobox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install figobox

## Usage

There is one method, which is `set`. You must provide either this method or the shorthand switch for it ("-s").

The `set` method accepts the following switches:

| Switch | Description |
|--------|-------------|
| <nobr>-d, --dry-run</nobr>     | (optional) Do a dry run. This will display the nanobox `evar` command, but will not execute it. You should always make sure the correct values will be set before doing so in production! |
| <nobr>-e, --figaro-environment</nobr>     | Specify the environment to use as the source from the application.yml file. |
| <nobr>-n, --nanobox-alias</nobr>     | (optional) Specify the nanobox alias where the environment variables should be set. This can be "local", "dry-run", or a remote alias. |

### Switch details:

#### --figaro-environment

This switch is required. The value should be the environment name from your application.yml file. Global values (top level values) in your application.yml file will be included, just as they are in Figaro.

#### --nanobox-alias

This switch is optional. The gem will use intelligent defaults to guess what the value should be, and will exit with an error message if it is unable to guess a value.

Here is a chart showing what values will be assumed if it is not provided:

| Figaro environment | Assumed value |
|--------------------|---------------|
| development        | local         |
| staging            | dry-run       |
| production         | \<blank\>     |

By leaving the production value blank, the app's remote will be used. If the app has more than one remote added, make sure you provide the one you want to set the values on.

### Example usage

To set your development variables, simply execute:

```
figobox set -e development
```

### Help

You can get more help by executing `figobox help` and `figobox help set`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brandoncc/figobox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Figobox project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/brandoncc/figobox/blob/master/CODE_OF_CONDUCT.md).

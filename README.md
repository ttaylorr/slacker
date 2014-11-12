# slacker 2
[![Build Status](https://travis-ci.org/ttaylorr/slacker.svg?branch=improvements)](https://travis-ci.org/ttaylorr/slacker)

<img src="http://i.imgur.com/tMom4oB.png" alt="slacker_icon" width="160" height="160" align="right">
Slacker is a collection of scripts for making [Slack](https://slack.com) a little better.
Slacker is maintained primarily by [ttaylorr](http://ttaylorr.com) and sits on the [Overcast Network](https://oc.tc) Slack room.

### installation

Clone down this repo on the box that you will be running Slacker on.

```
$ git clone git@github.com:ttaylorr/slacker && cd slacker
```

Once cloned, you'll need to do a few things.

1. Install all necessary gems by running `bundle install`.
2. Create a `.env` file and fill it out with the necessary tokens and info, as in `.env.example`.  (To make this easy, just `cp .env.example .env` and replace fill out the environment variables.

To start slacker invoke:

```
$ ruby bin/slacker.rb
```

### configuration

All configuration is contained in the `.env` file in the root of Slacker.

### contributing

If you wish to add a new script, write a plugin in the `lib/plugins` directory (and an accompanying test).  If anything about this is confusing, take a look at the existing patterns, and work from there.

Slacker makes it really easy to respond to messages using Regex.  Simply respond as in the following example:

```ruby
@slacker.respond /regex/ do |message, match|
  # the match variables are contained in `match`
  message.write(repsonse)
end
```

------

With :heart: from Slacker, enjoy.

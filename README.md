# slacker 2.1
[![Build Status](https://travis-ci.org/ttaylorr/slacker.svg?branch=improvements)](https://travis-ci.org/ttaylorr/slacker)

<img src="http://i.imgur.com/tMom4oB.png" alt="slacker_icon" width="160" height="160" align="right">
Slacker is a collection of scripts for making [Slack](https://slack.com) a little better.
Slacker is maintained primarily by [ttaylorr](http://ttaylorr.com) and sits on the [MCProHosting](https://mcprohosting.com) Slack room.

### contributing

If you wish to add a new script, write a plugin in the `lib/plugins` directory (and an accompanying test).  If anything about this is confusing, take a look at the existing patterns, and work from there.

Slacker makes it really easy to respond to messages using Regex.  Simply respond as in the following example:

```ruby
@slacker.respond /regex/ do |message, match|
  # the match variables are contained in `match`
  message.write(response)
end
```

Slacker also exposes a simple conversation API.  Need more info from a user when responding to a message?  The conversation API is perfect.

```ruby
@slacker.respond /conversation test/ do |message|
  message << 'What is your username on X again?'

  # This listener doens't need the 'slacker' prefix, and will be ignored unless
  # a previous message has been sent matching the outer regex.
  message.expect_reply /(.*)/ do |reply, match|
    # Do something with the reply that the user has given back...
    reply << "Oh! Your username is #{match[1]}"

    # The neat thing here is that since this block wont actually be triggered until
    # a reply is received, you can register *nested* replies!  Just repeat the
    # pattern above ad infinitum, and you can register a whole dialog!
  end
end
```


### installation

Clone down this repo on the box that you will be running Slacker on.

```
$ git clone git@github.com:ttaylorr/slacker && cd slacker
```

Once cloned, you'll need to do a few things.

1. Install all necessary gems by running `bundle install`.
2. Create a `.env` file and fill it out with the necessary tokens and info, as in `.env.example`.  (To make this easy, just `cp .env.example .env` and replace fill out the environment variables.

There is only one thing you have to provide details for in the `.env` file, `SLACK_TOKEN`.  If you're using Slack, you'll want to [create a bot user](https://api.slack.com/bot-users) and copy the token that slack gives you into the `.env` file.  If you want to use [redis](https://redis.io), you can set the `REDIS_HOST` and `REDIS_PORT` configuration options in your `.env` appropriately.

To start slacker invoke:

```
$ ruby bin/slacker.rb
```

### configuration

All configuration is contained in the `.env` file in the root of Slacker.

------

With :heart: from Slacker, enjoy.

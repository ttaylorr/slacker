# slacker [![Build Status](https://travis-ci.org/ttaylorr/slacker.svg?branch=improvements)](https://travis-ci.org/ttaylorr/slacker)

<img src="http://i.imgur.com/tMom4oB.png" alt="slacker_icon" width="160" height="160" align="right">
Slacker is a collection of scripts for making [Slack](https://slack.com) a little better.
Slacker is maintained primarily by [ttaylorr](http://ttaylorr.com) and sits on the [Overcast Network](https://oc.tc) Slack room.  Slacker helps us out with motivation, mundane tasks, and more!

### installation

Clone down this repo on the box that you will be running Slacker on.

```
$ git clone https://github.com/ttaylorr/slacker && cd slacker
```

Once cloned, install all the necessary gems by running:

```
bin/bootstrap
```

This step assumes you already have Ruby installed and in your path.

Put your Google Translate API key into your environment variables.  Do so by invoking the following:

```
$ export SLACKER_TRANSLATE_API_KEY=<your-key>
```

To start slacker invoke:

```
bin/start
```

You can configure the port that slacker runs on by editing `bin/start` and changing the `-p` value.

4. Now, log into Slack, and select to add a new integration.  Click on the 'Outgoing Web Hooks' integration, and scroll down to Integration Settings.  At this point, you can configure the channels that Slacker will listen to, trigger words, its label, apperance, etc.

5. Set your URL to `http://your-address.com:4567`.

6. To ensure that everything was installed correctly, go to a room that slacker is listening to, and ask slacker:

```
slacker are you there?
```

This assumes you haven't overriden Slackers name if so then use the override name.

If Slacker says `I am here!`, then you have done everything correctly.  Enjoy using Slacker!

### configuration

#### changing slacker's name

Copy `.env.sample` to `.env`

Edit `.env` and set a value for SLACKER_NAME_OVERRIDE

eg `SLACKER_NAME_OVERRIDE=holly`

Start your app and refer to slacker as `holly` and you are away!

If you are writing your own plugins you can gain access to this name (for use in help text) by using `SLACKER_NAME_OVERRIDE`.

### Plugin Libraries

[JSON Responder](using_json_responder.md)

### contributing

If you wish to add a new script, write a script in the `plugins/` directory, following the same format as `plugins/ping.rb`.  Slacker will automatically load your plugin, as long as you specify that it should be added to the bots list of plugins by dropping `Bot.register(<classname>)` in your plugin.

------

With :hearts: from Slacker, enjoy.

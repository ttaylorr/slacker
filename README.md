## slacker

<img src="http://i.imgur.com/tMom4oB.png" alt="slacker_icon" width="160" height="160" align="right">
Slacker is a collection of scripts for making [Slack](https://slack.com) a little better.
Slacker is maintained primarily by [ttaylorr](http://ttaylorr.com) and sits on the [Overcast Network](https://oc.tc) Slack room.  Slacker helps us out with motivation, mundane tasks, and more!

### installation

1. Clone down this repo on the box that you will be running Slacker on.

```
$ git clone https://github.com/ttaylorr/slacker && cd slacker
```

2. Once cloned, install all the necessary gems by running `bundle install`.  This step assumes you already have Ruby installed and in your path.

3. Once ready, start Slacker by either invoking `script/boostrap` or the following:

```
$ ruby app.rb -o 0.0.0.0
```

**Please note:** Slacker will *not* properly bind to your local address unless you tell it to bind with the `-o` flag.

4. Now, log into Slack, and select to add a new integration.  Click on the 'Outgoing Web Hooks' integration, and scroll down to Integration Settings.  At this point, you can configure the channels that Slacker will listen to, trigger words, its label, apperance, etc.

5. Set your URL to `http://your-address.com:4567`.

6. To ensure that everything was installed correctly, go to a room that slacker is listening to, and type `slacker ping`.  If you get a friendly `pong!` back, everything is working.

### contributing

If you wish to add a new script, write a script in the `plugins/` directory, following the same format as `plugins/ping.rb`.  Slacker will automatically load your plugin, as long as you specify that it should be added to the bots list of plugins by dropping `Bot.register(<classname>)` in your plugin.

------

With :hearts: from Slacker, enjoy.

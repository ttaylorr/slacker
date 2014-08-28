require 'net/http'
require 'openssl'
require 'json'

module Slacker
  class NewRelic < Plugin
    def help
      'Usage: slacker newrelic graph'
    end

    def pattern
      /newrelic graph/i
    end

    def respond (text, user_name, channel_name, timestamp)
      action, slacker, environment, *_ = text.split(" ")

      "vm6\nhttps://rpm.newrelic.com/public/charts/2MvxMtpUO3v\n\nvm01https://rpm.newrelic.com/public/charts/5U4XwNYqx1M"
    end

    Bot.register(NewRelic)
  end
end

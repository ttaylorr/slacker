<img src="http://i.imgur.com/tMom4oB.png" alt="slacker_icon" width="160" height="160" align="right">

### Using JSON Responder

The JSON Responder library makes it very easy to rapidly build plugins for Slacker that call an HTTP end point which returns a JSON payload.

This is extremely useful if you want Slacker to ask a service something about itself then have it display in Slack.

Here is a simple example:

```ruby
require_relative 'json_responder'

module Slacker
  class MyIP < Plugin
    include JSONResponder

    def help
      "slacker myip"
    end

    def pattern
      /myip/i
    end

    def url_for
      'http://jsonip.com'
    end

    def process_response (result)
      result["ip"]
    end

    Bot.register(MyIP)
  end
end
```

This will return (from the above URL):

```json
{"ip"=>"59.167.218.225, 202.177.218.91", "about"=>"/about", "Pro!"=>"http://getjsonip.com"}
```

So the process_response method simply returns what ever you want out of the JSON payload back to Slack.

```ruby
def process_response (result)
  result["ip"]
end
```

#### Authenticated (basic) calls and/or HTTPS

If you wanted to do a more complicated call to an HTTPS URL and have it do some basic authentication you could define the following for your url_for method:

```ruby
def url_for
  URI::Generic.build(
    scheme: "https",
    host: 'example.com',
    path: "/api/blah",
    port: 9999,
  ).tap do |uri|
    uri.user = 'username'
    uri.password = 'password'
  end.to_s
end
```

If your username has some "odd" characters in it (like an @) here is a way to handle that.

```ruby
def url_for(environment)
  URI::Generic.build(
    scheme: "https",
    host: 'example.com',
    path: "/api/blah",
    port: 9999,
  ).tap do |uri|
    uri.user = CGI.escape('blah@testing.com')
    uri.password = CGI.escape('123456')
  end.to_s
end
```

The JSON Responder uses the excom gem so you can get all usage information for that from there (https://github.com/excon/excon)



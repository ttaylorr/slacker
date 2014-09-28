### AWS list maintenance

This plugin is an example of what you can get slacker to return from your AWS Amazon account,
this particular example gives you a list of scheduled events that will effect any ec2
instasnces in your account, particularly around maintenance (ie system reboots) that AWS
are doing in the future.

Create a set of read only keys in your AWS console (IAM).

Set these keys in .env

```
AWS_ACCESS_KEY_ID=aaabbbcccddd
AWS_SECRET_KEY_ID=111222333444
```

These keys are then used by the plugin for authentication:

```ruby
AWS.config(
  :access_key_id     => ENV.fetch('AWS_ACCESS_KEY_ID'),
  :secret_access_key => ENV.fetch('AWS_SECRET_KEY_ID'))
```

An API call is then done

```ruby
api_result = ec2.client.describe_instance_status
```

in this case it calls on the `client.describe_instance_status` method, this AWS API is the one
that will return any scheduled events against ec2 instances in this account.

The plugin then collates the need info and assigns it to the output variable to return.

```ruby
api_result.instance_status_set.each { |instance|
  instance.events_set && instance.events_set.each { |event|
    output << "#{ec2.instances[instance.instance_id].tags["Name"]} (#{instance.instance_id} #{instance.availability_zone}) - #{event.description}, Not Before: #{event.not_before}, Not After: #{event.not_after}\n"
  }
}
```

The plugin outputs the following in slack:

```
Summary
mannys-mysql-client (i-3842cdd3 us-east-1a) - Scheduled reboot, Not Before: 2014-09-29 06:00:00 UTC, Not After: 2014-09-29 12:00:00 UTC
(i-0dbedae6 us-east-1a) - Scheduled reboot, Not Before: 2014-09-28 06:00:00 UTC, Not After: 2014-09-28 12:00:00 UTC
(i-0cbedae7 us-east-1a) - Scheduled reboot, Not Before: 2014-09-28 06:00:00 UTC, Not After: 2014-09-28 12:00:00 UTC
deis-DDD1A09E (i-0cdeb1e7 us-east-1a) - Scheduled reboot, Not Before: 2014-09-28 06:00:00 UTC, Not After: 2014-09-28 12:00:00 UTC
deis-CCFC2284 (i-90ec7a7d us-east-1b) - [Completed] Scheduled reboot, Not Before: 2014-09-27 06:00:00 UTC, Not After: 2014-09-27 12:00:00 UTC
deis-CCFC2284 (i-90ec7a7d us-east-1b) - [Completed] Scheduled reboot, Not Before: 2014-09-27 06:00:00 UTC, Not After: 2014-09-27 12:00:00 UTC
deis-DDD1A09E (i-3c4ddbd1 us-east-1b) - [Completed] Scheduled reboot, Not Before: 2014-09-27 06:00:00 UTC, Not After: 2014-09-27 12:00:00 UTC
deis-DDD1A09E (i-0e9317e0 us-east-1d) - Scheduled reboot, Not Before: 2014-09-30 06:00:00 UTC, Not After: 2014-09-30 12:00:00 UTC
```

There are hundreds of different calls that can be made, they are documented here.

http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html


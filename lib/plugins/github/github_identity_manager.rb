require 'octokit'

class GitHubIdentityManager
  def initialize(robot)
    @robot = robot
  end

  def make_octokit_user(chat_user)
    token = @robot.redis.get(make_key(chat_user))

    Octokit::Client.new(:access_token => token)
  end

  def revoke_token!(chat_user)
    @robot.redis.del(make_key(chat_user))
  end

  def set_token!(chat_user, token)
    @robot.redis.set(make_key(chat_user), token[:token])
  end

  private
  def make_key(chat_user)
    "github:#{chat_user["id"]}:oauth_token"
  end
end

require 'dotenv'
require 'octokit'
require 'pp'
require_relative '../../plugin'

module Slacker
  module Plugins
    class GitHubIdentityPlugin < Plugin
      def initialize(identity_manager)
        @identity_manager = identity_manager
      end

      def ready(robot)
        robot.respond /^(?:(?:gh|github) me)|(who am i on (?:github|gh)?)/i do |message|
          begin
            github_user = @identity_manager.make_octokit_user(message.user).user
            message << "You are #{github_user.login} on GitHub! :octocat:"
          rescue Octokit::Unauthorized => e
            message << "I don't know who you are on GitHub. (You can authenticate with \"slacker I am <your username> on GitHub\""
          end
        end

        robot.respond /(forget|erase|delete|remove) me ((?:on|from) (?:github|gh))/i do |message|
          @identity_manager.revoke_token!(message.user)
          message << "OK, I have no idea who you are on GitHub anymore."
        end

        robot.respond /i am (.*) on github/i do |message, match|
          github_username = match[1]

          message << "Okay, I'm going to authenticate you as #{github_username} on GitHub."
          message << "You can send me a direct message with your GitHub password so I can make an access token for you.  I promise I wont store it!"

          message.expect_reply /(.*)/ do |reply, password|
            user = Octokit::Client.new(:login => github_username,
                                       :password => password)

            if user.nil?
              reply << "Uh-oh! I couldn't manage to authenticate you with those credentials. Check your password and try again!"
            else
              begin
                # First login attempt
                set_token(robot, user, generate_oauth_token(user, nil), message)
              rescue Octokit::Unauthorized => e
                # Either the password was incorrect, (handled in the second rescue block),
                # or the user has 2FA enabled and hasn't sent down their token yet
                reply << "Great! Could you send your 2FA token over as well? If you don't have one, just say \"no token\"."

                reply.expect_reply /(.*)/ do |token_reply, token_match|
                  otp_token = token_match[1]
                  # Second login attempt, this time with either an incorrect password and no token
                  # (fail), or a correct password and a valid token (success)
                  begin
                    set_token(robot,
                              user,
                              generate_oauth_token(user, otp_token),
                              message)
                  rescue Octokit::Unauthorized => e
                    reply << "Hm, I wasn't able to authenticate you with those credentials. Sorry!"
                  end
                end
              end
            end
          end
        end
      end

      def generate_oauth_token(user, otp_token)
        authorization_args = {:scopes => ["user", "repo", ],
                              :note => "slacker integration token",
                              :client_id => ENV["GITHUB_CLIENT_ID"],
                              :client_secret => ENV["GITHUB_CLIENT_SECRET"]}

        if otp_token
          authorization_args[:headers] = {"X-GitHub-OTP" => otp_token}
        end

        user.create_authorization(authorization_args)
      end

      def set_token(robot, gh_user, token, message)
        @identity_manager.set_token!(message.user, token)

        robot.send_message "You are #{gh_user.login} on GitHub! :octocat:", message.channel
      end
    end
  end
end

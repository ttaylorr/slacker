module Slacker
  class JiraDatastore
    def initialize(robot)
      @robot = robot
    end

    def set_jira_username(robot, user, username)
      @robot.redis.set(make_jira_key(user), username)
    end

    def get_jira_username(robot, user)
      @robot.redis.get(make_jira_key(user))
    end

    def handle_username_change(username, message)
      begin
        jira_user = Jiralicious::User.find(username)
        set_jira_username(@robot, message.user, jira_user.name)

        message << "OK, you are *#{jira_user.name}* on JIRA"
      rescue Exception => e
        message << "I couldn't find a user named #{username} on JIRA :disappointed:"
      end
    end

    private
    def make_jira_key(user)
      "jira:#{user["id"]}:username"
    end
  end
end 

module Slacker
  class ScopedListener < Listener
    attr_reader :user

    def initialize(user, regex, callback)
      super(regex, callback)

      @user = user
      @conversational = true
    end

    # Override the behavior of the superclass Listener to ensure that the
    # user also matches
    def hears?(message)
      if @user["name"] == message.user["name"]
        self.regex.match(message.original_message)
      else
        nil
      end
    end
  end
end

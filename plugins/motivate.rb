module Slacker
  class Motivate < Plugin
    # Remarks from the lovely Hubot
    @@remarks_one = [
      "Great job, %!",
      "Way to go, %!",
      "% is amazing, and everyone should be happy this amazing person is around.",
      "I wish I was more like %.",
      "% is good at like, 10 times more things than I am.",
      "%, you are an incredibly sensitive person who inspires joyous feelings in all those around you.",
      "%, you are crazy, but in a good way.",
      "% has a phenomenal attitude.",
      "% is a great part of the team!",
      "I admire %'s strength and perseverance.",
      "% is a problem-solver and cooperative teammate.",
      "% is the wind beneath my wings.",
      "% has a great reputation."
    ]

    @@remarks_all = [
      "Great job today, everyone!",
      "Go team!",
      "Super duper, gang!",
      "If I could afford it, I would buy you all lunch!",
      "What a great group of individuals there are in here. I'm proud to be chatting with you.",
      "You all are capable of accomplishing whatever you set your mind to.",
      "I love this team's different way of looking at things!"
    ]

    def pattern
      /motivate\s(me|us)?/
    end

    def respond (text, user_name, channel_name, timestamp)
      message = @@remarks_one.sample
      if (text.include? 'me')
        message.gsub! '%', user_name
      elsif (text.include? 'us')
        message = @@remarks_all.sample
      else
        address = pattern.match(text)
        motivated = text[address.end(0)+1..motivated.length()]

        message.gsub! '%', motivated
      end
      return message
    end

    Bot.register(Motivate)
  end
end

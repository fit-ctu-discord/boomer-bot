module BoomerBot
  module Listeners

    class GoodBotListener

      def initialize(bot)
        @bot = bot
        @config = BoomerBot::CONFIG
        @boomer_channel = @bot.channel @config[:boomers_channel_id]
      end

      def register
        @bot.message(in: @boomer_channel) do |event|
          message = event.message
          # The bot really likes to hear that he is good, best etc.
          if message.content.match(/^(good|best|the best) bot/i)
            # So he will say his thank you through the heart emote
            message.create_reaction '🤖'
            message.create_reaction %w[❤️ 💕 💖].sample
          end
        end
      end
    end
  end
end
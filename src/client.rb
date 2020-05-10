# frozen_string_literal: true

require 'discordrb'
require_relative 'boomer_emote_listener'
require_relative 'good_bot_listener'

bot = Discordrb::Bot.new token: BoomerBot::DISCORD_TOKEN

puts 'Created the bot instance'
puts "Invite url: #{bot.invite_url permission_bits: 268_822_592}"

BoomerBot::Listeners::BoomerEmoteAddedListener.new(bot).register
BoomerBot::Listeners::GoodBotListener.new(bot).register

# Updating the presence status requires the gateway to be connected
bot.ready do
  # This feature should be documented tbh, no more source code crawling pls
  bot.update_status nil, 'with boomers', nil
end

bot.run

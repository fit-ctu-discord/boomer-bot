require 'discordrb'
require_relative 'boomer_emote_listener'

bot = Discordrb::Bot.new token: BoomerBot::DISCORD_TOKEN

puts 'Created the bot instance'
puts "Invite url: #{bot.invite_url permission_bits: 268822592}"

BoomerBot::Listeners::BoomerEmoteAddedListener.new(bot).register

bot.run


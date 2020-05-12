# frozen_string_literal: true

module BoomerBot
    module Listeners
        class XDMessagesListener
            def initialize(bot)
                @bot = bot
                @config = BoomerBot::CONFIG
            end

            def register 
                @bot.message do |event|
                    # Do not react to messages outside the meme and planet commedy
                    next unless [@config[:boomers_channel_id], @config[:meme_channel_id]].include?(event.channel.id)

                    message = event.message

                    pattern = /(?:(?:x|:regional_indicator_x:)+\s*(?:d|:regional_indicator_d:)+(?:[\s\W]|$)|iks\s*d[eé]?)/i

                    if message.content.match pattern
                        react_with_boomer event
                    end
                end
            end

            # Mark the boomer with the sign of true evil
            def react_with_boomer(event)
                @boomer_emote ||= event.server.emoji[@config[:boomer_emote_id]]
                event.message.create_reaction @boomer_emote
            end
        end
    end
end
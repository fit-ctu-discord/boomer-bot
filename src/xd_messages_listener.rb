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
                    message = event.message

                    # No xd in my swamp
                    if message.content.match(/xd/i)
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
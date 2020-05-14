# frozen_string_literal: true

require_relative 'boomer_image'

module BoomerBot
  module Listeners
    # The main listener watching out for boomers arising in the meme channel
    class BoomerEmoteAddedListener
      def initialize(bot)
        @bot = bot
        @config = BoomerBot::CONFIG
        @meme_channel = @bot.channel @config[:meme_channel_id]
        @boomer_channel = @bot.channel @config[:boomers_channel_id]
        @messages_to_process = []
      end

      def register
        @bot.reaction_add do |event|
          # If the reaction is a boomer emote in the meme channel
          if (event.emoji.id == @config[:boomer_emote_id]) && (event.channel.id == @config[:meme_channel_id])

            # We can assume that the user is instance of Discordrb::Member
            user = event.message.user

            protected_roles = [
              @config[:meme_master_role_id],
              @config[:staff_role_id]
            ]

            # Is the sender member of the elite meme master society or the Staff?
            is_protected = user.roles.any? { |role| protected_roles.include?(role.id) }

            unless is_protected || @messages_to_process.include?(event.message.id)
              boomer_reactions = event.message.reactions[event.emoji.name].count

              # If the boomer potential is too high to handle
              if boomer_reactions >= @config[:boomer_emote_threshold]
                @messages_to_process.push event.message.id
                send_boomer_alert event
                yeet event
                @messages_to_process.delete event.message.id
              end
            end
          end
        end
      end

      private

      def send_boomer_alert(event)
        user = event.message.user
        already_boomer = user.roles.any? { |role| role.id == @config[:boomer_role_id] }

        if already_boomer
          image = BoomerBot::Image.already_a_boomer_image
          description = 'How many times do we have to teach you this lesson old man?'
        else
          image = BoomerBot::Image.introduction_image
          description = 'Ladies and gentlemen, allow me to introduce a new boomer over here.'

          # Give the user a boomer role, so he could feel ashamed
          add_boomer_role_to_user event
        end

        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Boomer alert!'
        embed.description = description
        embed.color = '#E0115F'
        embed.image = Discordrb::Webhooks::EmbedImage.new url: image
        embed.add_field name: 'Boomer', value: user.mention, inline: true

        boomers_count = event.server.members.count do |member|
          member.roles.any? do |role|
            role.id == @config[:boomer_role_id]
          end
        end
        embed.add_field name: 'Total number of boomers on this server', value: boomers_count

        # Announce a new boomer / meme
        @boomer_channel.send_message(nil, nil, embed)
      end

      def add_boomer_role_to_user(event)
        boomer_role = event.server.roles.find { |role| role.id == @config[:boomer_role_id] }
        event.message.user.add_role boomer_role
      end

      def yeet(event)
        message = event.message

        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'posted'
        embed.author = Discordrb::Webhooks::EmbedAuthor.new name: message.user.username,
                                       icon_url: message.user.avatar_url
        embed.description = message.content
        embed.timestamp = message.timestamp
        embed.color = '#E0115F'

        # Connect image attachments as embed image, all other attachments as their url
        message.attachments.each do |attachment|
          if attachment.image? && (!attachment.url.end_with? '.mp4')
            embed.image = Discordrb::Webhooks::EmbedImage.new url: attachment.url
          else
            embed.add_field name: 'Attached file', value: attachment.url
          end
        end

        # Repost the boomer message to planet comedy
        @boomer_channel.send_message(nil, nil, embed)

        # Finally delete the message in meme channel
        event.message.delete
      end
    end
  end
end

package dev.vrba

import org.javacord.api.DiscordApi
import org.javacord.api.entity.channel.ServerTextChannel
import org.javacord.api.entity.emoji.KnownCustomEmoji
import org.javacord.api.entity.message.Message
import org.javacord.api.entity.message.embed.EmbedBuilder
import org.javacord.api.entity.user.User
import org.javacord.api.event.message.MessageCreateEvent
import org.javacord.api.event.message.reaction.ReactionAddEvent
import org.javacord.api.listener.message.MessageCreateListener
import org.javacord.api.listener.message.reaction.ReactionAddListener
import java.awt.Color

class BoomerBot
    (
    private val client: DiscordApi,
    private val config: BoomerBotConfig
)
{
    private val boomerEmoji: KnownCustomEmoji = this.client
        .getCustomEmojiById(config.boomerEmoji)
        .orElseThrow {
            throw RuntimeException("Cannot find boomer emoji by its id: " + config.boomerEmoji)
        }

    private inner class MessageListener : MessageCreateListener
    {
        override fun onMessageCreate(event: MessageCreateEvent)
        {
            if (this.shouldReactTo(event))
            {
                event.message.addReaction("💖")
            }
        }

        private fun shouldReactTo(event: MessageCreateEvent): Boolean
        {
            val channel = event.channel ?: return false
            val content = event.message.content

            return channel.id == config.boomersChannelId &&
                   content.toLowerCase().startsWith("good bot")
        }
    }

    private inner class ReactionListener : ReactionAddListener
    {
        override fun onReactionAdd(event: ReactionAddEvent)
        {
            if (this.shouldReactTo(event))
            {
                // Why the fuck is this not implemented within the library?
                val message = event.channel.getMessageById(event.messageId).join()
                val boomerReactions = message.reactions.find { it.emoji.equalsEmoji(boomerEmoji) }
                val count = boomerReactions?.count ?: 0
                
                if (count >= config.boomerEmojiThreshold)
                {
                    val channel = event.channel.asServerTextChannel()
                        .orElseThrow { throw RuntimeException("Cannot get channel from the message.") }
                    
                    yeetToBoomerChannel(channel, message)
                }
            }
        }
        
        private fun shouldReactTo(event: ReactionAddEvent): Boolean
        {
            val channel = event.channel ?: return false
            val emoji = event.emoji
            
            return channel.id == config.memeChannelId && // Was the reaction given in the meme channel?
                    emoji.equalsEmoji(boomerEmoji)       // the reaction was the boomer emoji
        }
    }
    
    fun start()
    {
        this.client.addReactionAddListener(ReactionListener())
    }
    
    
    private fun yeetToBoomerChannel(memeChannel: ServerTextChannel, message: Message)
    {
        val server = memeChannel.server
        val author = message.author
            .asUser()
            .orElseThrow {
                throw RuntimeException("Cannot use message author as user. wtf.")
            }
        
        // Meme masters cannot be marked as boomers
        if (author.getRoles(server).any { it.id == config.memeMasterRoleId })
        {
            return
        }
        
        val boomersChannel = server.getChannelById(config.boomersChannelId)
            .orElseThrow { throw RuntimeException("Cannot get boomers channel by id: ${config.boomersChannelId}") }
            .asServerTextChannel()
            .orElseThrow { throw RuntimeException("Cannot typecast boomers channel to server text channel.") }
        
        if (this.shouldIntroduceNewClown(message, author))
        {
            val boomerRole = server.roles.first { it.id == config.boomerRoleId }
            val boomersCount = server.members.count { it.getRoles(server).contains(boomerRole) } + 1
            
            val embed = EmbedBuilder()
                .setTitle("Ladies and gentlemen, allow me to introduce a new boomer over here.")
                .setDescription("Currently, there are **$boomersCount** boomers on this server")
                .setAuthor(author)
                .setImage(BoomerImage.forIntroduction)
                .setColor(Color.RED)
            
            boomersChannel.sendMessage(embed).join()
            
            author.addRole(boomerRole).join()
        }
        else
        {
            // The user is already a proven boomer
            val embed = EmbedBuilder()
                .setTitle("Boomer Alert!")
                .setAuthor(author)
                .setImage(BoomerImage.forRepeatedBoomerPosting)
                .setColor(Color.RED)
            
            boomersChannel.sendMessage(embed).join()
        }
        
        val embed = EmbedBuilder()
            .setAuthor(message.author)
            .setDescription(message.content)
            .setTimestamp(message.creationTimestamp)
        
        // If the meme contains an image, embed it
        if (message.attachments.isNotEmpty())
        {
            embed.setImage(message.attachments[0].url.toString())
        }
        
        // Repost the meme to boomers channel
        boomersChannel
            .sendMessage(embed)
            .join()
        
        // Finally, delete the original message
        message.delete()
            .join()
    }
    
    private fun shouldIntroduceNewClown(message: Message, author: User): Boolean
    {
        val server = message.server.orElseThrow { throw RuntimeException("Cannot get server from the message. wtf.") }
        
        // If the user doesn't have the Boomer role yet
        return author.getRoles(server).none { it.id == config.boomerRoleId }
    }
    
}

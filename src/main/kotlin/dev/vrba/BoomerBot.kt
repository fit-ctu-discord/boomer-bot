package dev.vrba

import org.javacord.api.DiscordApi
import org.javacord.api.entity.emoji.KnownCustomEmoji
import org.javacord.api.event.message.reaction.ReactionAddEvent
import org.javacord.api.listener.message.reaction.ReactionAddListener

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
    
    private inner class ReactionListener : ReactionAddListener
    {
        override fun onReactionAdd(event: ReactionAddEvent?)
        {
            // Only react to boomer emojis being added as reaction
            println(event)
        }
    }
    
    fun start()
    {
        this.client.addReactionAddListener(ReactionListener())
    }
}

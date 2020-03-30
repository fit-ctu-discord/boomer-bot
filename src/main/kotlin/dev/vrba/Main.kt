package dev.vrba

import org.javacord.api.DiscordApiBuilder
import java.lang.RuntimeException

private fun env(key: String): String =
    System.getenv(key) ?: throw RuntimeException("Cannot find $key in the process env")

fun main()
{
    val token = env("DISCORD_TOKEN")
    
    val client = DiscordApiBuilder()
        .setToken(token)
        .login()
        .join()
    
    val config = BoomerBotConfig(
        env("MEME_CHANNEL_ID").toLong(),
        env("BOOMERS_CHANNEL_ID").toLong(),
        env("BOOMER_ROLE_ID").toLong(),
        env("MEME_MASTER_ROLE_ID").toLong(),
        env("BOOMER_EMOJI_ID").toLong(),
        env("BOOMER_EMOJI_THRESHOLD").toInt()
    )
    
    val app = BoomerBot(client, config)
    
    app.start()
}
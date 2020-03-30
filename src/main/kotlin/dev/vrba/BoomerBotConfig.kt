package dev.vrba

data class BoomerBotConfig(
    val memeChannelId: Long,
    val boomersChannelId: Long,
    val boomerRoleId: Long,
    val memeMasterRoleId: Long,
    val boomerEmoji: Long,
    val boomerEmojiThreshold: Int
)

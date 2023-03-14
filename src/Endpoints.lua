endpoints = {
    USER_ME = '/users/@me',
    
    CHANNEL = '/channels/%s',
    CHANNEL_INVITES = "/channels/%s/invites",
	CHANNEL_MESSAGE = "/channels/%s/messages/%s",
	CHANNEL_MESSAGES = "/channels/%s/messages",
	CHANNEL_MESSAGES_BULK_DELETE = "/channels/%s/messages/bulk-delete",
	CHANNEL_MESSAGE_REACTION = "/channels/%s/messages/%s/reactions/%s",
	CHANNEL_MESSAGE_REACTIONS = "/channels/%s/messages/%s/reactions",
	CHANNEL_MESSAGE_REACTION_ME = "/channels/%s/messages/%s/reactions/%s/@me",
	CHANNEL_MESSAGE_REACTION_USER = "/channels/%s/messages/%s/reactions/%s/%s",
	CHANNEL_PERMISSION = "/channels/%s/permissions/%s",
	CHANNEL_PIN = "/channels/%s/pins/%s",
	CHANNEL_PINS = "/channels/%s/pins",
	CHANNEL_WEBHOOKS = "/channels/%s/webhooks",

    GUILD = '/guilds/%s',
    GUILD_MEMBER = '/guilds/%s/members/%s',
}
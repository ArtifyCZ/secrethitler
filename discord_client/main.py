import discord
from decouple import config


token = config("TOKEN")
bot = discord.Bot()
guild_ids = [int(config("GUILD"))]

@bot.event
async def on_ready():
    print(f"""
    Welcome to Secter Hitler Discord bot!
    This Discord bot is supposed to bridge Secret Hitler game to Discord,
    so you can play along with your friends there.

    Logged as {bot.user}
    """)

@bot.slash_command(guild_ids=guild_ids)
async def ping(ctx):
    await ctx.respond("Pong!")

bot.run(token)
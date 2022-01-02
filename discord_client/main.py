import discord
from decouple import config


token = config("TOKEN")
bot = discord.Bot()
guild_ids = [int(config("GUILD"))]

@bot.event
async def on_ready():
    print(f"We have logged in as {bot.user}")

@bot.slash_command(guild_ids=guild_ids)
async def ping(ctx):
    await ctx.respond("Pong!")

bot.run(token)
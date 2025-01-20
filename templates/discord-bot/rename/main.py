import logging
import os
import sys

from disnake import Guild, Intents, Message
from disnake.ext import commands
from disnake.ext.commands import Bot
from dotenv import find_dotenv, load_dotenv

from .db import setup_db

# Logger setup
logger_disnake = logging.getLogger("disnake")
logger_disnake.setLevel(logging.WARNING)

log = logging.getLogger("rename")
log.setLevel(logging.DEBUG)

formatter = logging.Formatter("%(asctime)s:%(levelname)s:%(name)s: %(message)s")
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(formatter)
logger_disnake.addHandler(handler)
log.addHandler(handler)


if load_dotenv(find_dotenv(usecwd=True)):
    log.debug("Loaded .env")
else:
    log.debug("Didn't find .env")

TOKEN = os.getenv("TOKEN")
DB_FILE = os.getenv("DB_FILE") or "rename.sqlite3"
DEFAULT_PREFIX = os.getenv("DEFAULT_PREFIX") or ">>>"


async def get_prefix(the_bot, message: Message):
    if not message.guild:
        return commands.when_mentioned_or(DEFAULT_PREFIX)(the_bot, message)

    gp = await the_bot.get_guild_prefix(message.guild)

    if gp == "":
        return commands.when_mentioned(the_bot, message)

    return commands.when_mentioned_or(gp)(the_bot, message)


class Rename(Bot):
    def __init__(self, prefix, description=None, **options):
        super().__init__(
            prefix,
            description=description,
            command_sync_flags=options.get("sync_flags"),
            allowed_mentions=options.get("allowed_mentions"),
            intents=options.get("intents"),
        )

        self.db = self.loop.run_until_complete(setup_db(DB_FILE))
        self.prefixes = {}

    async def get_guild_prefix(self, guild: Guild):
        if guild.id in self.prefixes:
            return self.prefixes[guild.id]

        cur = await self.db.execute(
            "SELECT prefix FROM guilds WHERE guild_id=? LIMIT 1",
            [guild.id],
        )
        prefix = await cur.fetchone() or [DEFAULT_PREFIX]
        prefix = prefix[0]

        self.prefixes[guild.id] = prefix
        return prefix

    async def set_guild_prefix(self, guild: Guild, prefix):
        await self.db.execute(
            "REPLACE INTO guilds VALUES(?, ?)",
            (guild.id, prefix),
        )
        self.prefixes[guild.id] = prefix

    async def close(self):
        await super().close()
        await self.db.close()


bot = Rename(
    prefix=get_prefix,
    description="@description@",
    intents=Intents(
        guilds=True,
        messages=True,
        message_content=True,
    ),
    sync_flags=commands.CommandSyncFlags(
        sync_commands=False,
    ),
)


@bot.event
async def on_ready():
    log.info("Logged in as:")
    log.info(bot.user)
    log.info(bot.user.id)
    log.info("-------------")


@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, commands.CommandNotFound):
        return

    if isinstance(error, commands.NoPrivateMessage):
        await ctx.send(error)
        return

    log.exception(error)
    await ctx.send(error)


@bot.command()
@commands.is_owner()
async def echo(ctx, arg):
    await ctx.send(arg)


@bot.command()
async def ping(ctx):
    await ctx.send("Pong")


@bot.command()
@commands.guild_only()
@commands.is_owner()
async def prefix(ctx, prefix=None):
    if prefix is None:
        prefix = await ctx.bot.get_guild_prefix(ctx.guild)
        if prefix == "":
            await ctx.send(f"{ctx.guild.name} prefix is mentioning me only")
        else:
            await ctx.send(f"{ctx.guild.name} prefix is `{prefix}`")
    else:
        await ctx.bot.set_guild_prefix(ctx.guild, prefix)
        if prefix == "":
            await ctx.send(f"Set {ctx.guild.name} prefix to mentioning me only")
        else:
            await ctx.send(f"Set {ctx.guild.name} prefix to `{prefix}`")


def run():
    bot.run(TOKEN)

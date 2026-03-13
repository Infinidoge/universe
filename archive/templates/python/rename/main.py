import logging
import os
import sys

from dotenv import find_dotenv, load_dotenv

# Logger setup
logging.basicConfig(
    format="{asctime} {levelname:8} {name}: {message}",
    datefmt="%Y-%m-%d %H:%M:%S",
    style="{",
    stream=sys.stdout,
    force=True,
)

log = logging.getLogger("rename")
log.setLevel(logging.DEBUG)

if load_dotenv(find_dotenv(usecwd=True)):
    log.debug("Loaded .env")
else:
    log.debug("Didn't find .env")

TOKEN = os.getenv("TOKEN")


def run():
    pass

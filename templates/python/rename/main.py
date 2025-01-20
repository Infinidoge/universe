import logging
import os
import sys

from dotenv import find_dotenv, load_dotenv

# Logger setup

log = logging.getLogger("rename")
log.setLevel(logging.DEBUG)

formatter = logging.Formatter("%(asctime)s:%(levelname)s:%(name)s: %(message)s")
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(formatter)
log.addHandler(handler)


if load_dotenv(find_dotenv(usecwd=True)):
    log.debug("Loaded .env")
else:
    log.debug("Didn't find .env")

TOKEN = os.getenv("TOKEN")


def run():
    pass

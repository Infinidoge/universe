import aiosqlite


async def setup_db(db_file):
    db = await aiosqlite.connect(db_file)

    await db.executescript("""
    BEGIN;

    CREATE TABLE IF NOT EXISTS guilds (
        guild_id INTEGER NOT NULL PRIMARY KEY,
        prefix TEXT NOT NULL DEFAULT ">"
    )
    WITHOUT ROWID;

    # DB Setup here

    COMMIT;

    PRAGMA optimize(0x10002);
    PRAGMA main.synchronous = NORMAL;
    """)

    return db


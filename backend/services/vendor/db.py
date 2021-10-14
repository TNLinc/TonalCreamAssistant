from typing import Optional

from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession, create_async_engine

engine: Optional[AsyncEngine] = None


async def start_db(db_url: str):
    global engine  # pylint: disable=global-statement
    engine = create_async_engine(db_url)


async def close_db():
    global engine  # pylint: disable=global-variable-not-assigned
    if engine:
        await engine.dispose()


async def get_db() -> AsyncSession:
    async with AsyncSession(engine) as session:
        yield session

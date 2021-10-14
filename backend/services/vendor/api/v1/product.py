import uuid
from typing import List, Optional

from fastapi import Depends, HTTPException
from fastapi_utils.cbv import cbv
from fastapi_utils.inferring_router import InferringRouter
from pydantic.color import Color
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload
from sqlmodel import select

from db import get_db
from models import Product, ProductRead, ProductWithVendor

router = InferringRouter()


@cbv(router)
class ProductAPI:
    session: AsyncSession = Depends(get_db)

    @router.get("/products/{item_id}")
    async def get_vendor(self, item_id: uuid.UUID) -> ProductWithVendor:
        product = await self.session.get(
            Product, item_id, options=[joinedload(Product.vendor)]
        )
        if not product:
            raise HTTPException(status_code=404, detail="Vendor not found")
        return product

    @router.get("/products")
    async def get_all_vendors(self, color: Optional[Color] = None) -> List[ProductRead]:
        stmt = select(Product)
        if color:
            print(color)
            stmt = stmt.filter_by(color=color.as_hex())
        result = await self.session.execute(stmt)
        return result.scalars().all()

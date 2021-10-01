import uuid
from enum import Enum
from typing import List, Optional

import sqlalchemy as sa
from pydantic.color import Color
from sqlalchemy_utils import ChoiceType
from sqlmodel import Field, Relationship
from sqlmodel import SQLModel

from core import settings


class VendorBase(SQLModel):
    name: str
    url: str


class Vendor(VendorBase, table=True):
    id: Optional[uuid.UUID] = Field(default=uuid.uuid4(), primary_key=True)
    products: List["Product"] = Relationship(back_populates='vendor')

    __table_args__ = {"schema": settings.DB_AUTH_SCHEMA}

    class Config:
        schema_extra = {
            "example": {
                "id": "028e5753-1992-4f3a-8691-65ba82442c19",
                "name": "Laurel",
                "url": "https://slugify.online",
            }
        }


class VendorRead(VendorBase):
    id: Optional[uuid.UUID]


class ProductType(Enum):
    TONAL_CREAM = "TONAL_CREAM"


class ProductBase(SQLModel):
    name: str
    type: ProductType = Field(sa_column=sa.Column(ChoiceType(ProductType, impl=sa.String())), nullable=False)
    color: Color = Field(nullable=False)
    vendor_id: uuid.UUID = Field(foreign_key='vendor.vendor.id')


class Product(ProductBase, table=True):
    id: Optional[uuid.UUID] = Field(default=uuid.uuid4(), primary_key=True)
    vendor: Vendor = Relationship(back_populates='products')

    __table_args__ = {"schema": settings.DB_AUTH_SCHEMA}

    class Config:
        schema_extra = {
            "example": {
                "id": "028e5753-1992-4f3a-8691-65ba82442c19",
                "name": "Cream nature",
                "type": "TONAL_CREAM",
                "color": "#FFA1F8",
                "vendor_id": Vendor.Config.schema_extra
            }
        }


class ProductRead(ProductBase):
    id: Optional[uuid.UUID]


class VendorWithProducts(VendorRead):
    products: List[ProductRead] = []


class ProductWithVendor(ProductRead):
    vendor: VendorRead

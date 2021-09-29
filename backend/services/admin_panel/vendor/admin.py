from django.contrib import admin
from vendor.models import Product, Vendor


class ProductInLine(admin.StackedInline):
    model = Product
    extra = 0


@admin.register(Vendor)
class SubAdmin(admin.ModelAdmin):
    list_display = ("name", "url")
    search_fields = ("id", "name")
    inlines = [ProductInLine]


@admin.register(Product)
class SubAdmin(admin.ModelAdmin):
    list_display = ("name", "type", "color")
    search_fields = ("id", "type", "name", "color")

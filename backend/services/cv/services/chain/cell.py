from abc import ABC, abstractmethod
from typing import Any


class Cell(ABC):
    @abstractmethod
    def set_next(self, next_cell: "Cell") -> "Cell":
        ...

    @abstractmethod
    def __call__(self, context: Any):
        ...


class AbstractCell(Cell):
    _next_cell: Cell = None

    def set_next(self, next_cell: "Cell") -> "Cell":
        self._next_cell = next_cell

    def __call__(self, context: Any):
        if self._next_cell:
            return self._next_cell(context=context)

        return None


class CellFromFabric(AbstractCell):
    def __init__(self, fabric: dict, item_name: str):
        self._item = fabric[item_name]

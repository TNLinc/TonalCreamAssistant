from typing import Any, List

from services.chain.cell import Cell


class Chain:
    def __init__(self, cells: List[Cell]):
        self._start_chain = cells[0]

        for i, cell in enumerate(cells[:-1]):
            cell.set_next(cells[i + 1])

    def process(self, context: Any) -> Any:
        self._start_chain(context=context)
        return context

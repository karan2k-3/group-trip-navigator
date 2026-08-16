import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from tools import TOOL_DISPATCH
from tools.tool_schemas import TOOLS


def test_every_schema_has_a_dispatch_entry():
    schema_names = {t["name"] for t in TOOLS}
    dispatch_names = set(TOOL_DISPATCH.keys())
    assert schema_names == dispatch_names, (
        "Mismatch between tool_schemas.py and TOOL_DISPATCH — "
        "every tool the LLM can request must be executable."
    )

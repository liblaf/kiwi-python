from collections.abc import Callable, Iterable
from pathlib import Path

import platformdirs

from liblaf.kiwi._version import __version__

dirs = platformdirs.AppDirs(
    appname="liblaf/kiwi", appauthor="liblaf", version=__version__
)
iter_data_paths: Callable[[], Iterable[Path]] = dirs.iter_data_paths


def find_data_path(filename: str) -> Path | None:
    for path in iter_data_paths():
        candidate: Path = path / filename
        if candidate.exists():
            return candidate
    return None

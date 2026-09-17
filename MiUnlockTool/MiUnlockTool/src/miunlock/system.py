import os
import platform
import stat

from migate.config import console, ORANGE, WHITE, DIM, RED, GREEN

SYSTEM = platform.system()
IS_TERMUX = "com.termux" in os.environ.get("PREFIX", "") or os.path.isdir("/data/data/com.termux/files/usr")


def make_executable(path):
    if SYSTEM not in ("Linux", "Darwin", "Android"):
        return
    st = os.stat(path)
    if os.getuid() == st.st_uid:
        x_bit = stat.S_IXUSR
    elif os.getgid() == st.st_gid:
        x_bit = stat.S_IXGRP
    else:
        x_bit = stat.S_IXOTH
    if not (st.st_mode & x_bit):
        os.chmod(path, st.st_mode | x_bit)

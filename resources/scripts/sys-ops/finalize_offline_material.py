import os
import pathlib
import sys
import shutil as sh
import subprocess
import contexttimer
import datetime as dt

flag_render = True

commands_dict = {
    "render book": {
        "cmd": "quarto render book",
        "status": True,
        },
    "aggregate slides": {
        "cmd": "./.py-venv/bin/python3 ./resources/scripts/sys-ops/slides/merge_qmd.py",
        "status": True,
    },
    "render slides handout": {
        "cmd": "quarto render slides --profile handout",
        "status": True
    },
    "render slides ppt": {
        "cmd": "quarto render slides --profile ppt",
        "status": True
    },
}

for key in commands_dict:
    if commands_dict[key]["status"] and flag_render:
        with contexttimer.Timer() as t:
            print(f"running: {key}")
            subprocess.run(commands_dict[key]["cmd"], shell=True,\
                            check=True, stdout=subprocess.DEVNULL, \
                                stderr=subprocess.STDOUT)
        elpsd_min = int(round(t.elapsed/60, 0))
        elpsd_sec = int(round(t.elapsed%60, 0))
        print(f"{key}: {elpsd_min}m: {elpsd_sec}s")

dst_path = pathlib.Path("itppy-package")

if dst_path.exists():
    sh.rmtree(dst_path)

dst_book = dst_path.joinpath("book")
book_path = pathlib.Path("book/_book")
dst_book.mkdir(parents=True, exist_ok=True)
sh.copytree(src=book_path, dst=dst_book, dirs_exist_ok=True)

dst_slides = dst_path.joinpath("slides")
dst_slides.mkdir(parents=True, exist_ok=True)
slides_root_path = pathlib.Path("slides/_slides/")
slides_paths_handout = [*slides_root_path.rglob("**/itppy*handout.pdf")][0]
slides_paths_ppt = [*slides_root_path.rglob("**/itppy*ppt.pdf")][0]
sh.copy2(src=slides_paths_handout, \
         dst=dst_slides.joinpath(slides_paths_handout.name))
sh.copy2(src=slides_paths_ppt, \
         dst=dst_slides.joinpath(slides_paths_ppt.name))


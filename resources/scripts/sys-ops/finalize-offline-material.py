import subprocess
import pathlib
import shutil as sh

import render

cmd = "bash resources/scripts/sys-ops/check-current-directory.sh"
subprocess.run(cmd, shell=True, check=True,
               stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)

dst_name = "itppy-package"
dst_path = pathlib.Path(dst_name)

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
sh.copy2(src=slides_paths_handout,
         dst=dst_slides.joinpath(slides_paths_handout.name))
sh.copy2(src=slides_paths_ppt,
         dst=dst_slides.joinpath(slides_paths_ppt.name))

sh.make_archive(dst_name, format="zip", root_dir=dst_path)

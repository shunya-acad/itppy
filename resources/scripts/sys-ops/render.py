import subprocess
import contexttimer
import slides.merge_qmd

flag_render = True

commands_dict = {
    "render book": {
        "cmd": "quarto render book",
        "status": True,
        },
    # "aggregate slides": {
    #     "cmd": "./.py-venv/bin/python3 ./resources/scripts/sys-ops/slides/merge_qmd.py",
    #     "status": True,
    # },
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

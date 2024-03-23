import subprocess
import contexttimer

flag_render = True

commands_dict = {
    "render book": {
        "cmd": "bash ./resources/scripts/sys-ops/finalize-book.sh",
        "status": True,
    },
    "prepare aggregate slides": {
        "cmd": "bash ./resources/scripts/sys-ops/prepare-slides-aggregate.sh",
        "status": True,
    },
    "render slides handout": {
        "cmd": "quarto render slides --profile handout",
        "status": True,
    },
    "render slides ppt": {
        "cmd": "quarto render slides --profile ppt",
        "status": True},
}

for key in commands_dict:
    if commands_dict[key]["status"] and flag_render:
        with contexttimer.Timer() as t:
            print(f"running: {key}")
            subprocess.run(commands_dict[key]["cmd"], shell=True, check=True,
                           stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
        elpsd_sec = int(round(t.elapsed % 60, 0))
        elpsd_min = int(round(t.elapsed / 60, 0))
        print(f"{key}: {elpsd_min}m: {elpsd_sec}s")

import pathlib
import yaml
import re
import shutil as sh

root_path = pathlib.Path("slides")
book_yaml_path = pathlib.Path("book/_quarto.yml")
file_path_out = pathlib.Path("slides/content/.aggregate/itppy-slides.qmd")
template_path = pathlib.Path("slides/.config/templates/itppy_slides_template.qmd")

file_path_out.unlink(missing_ok=True)
sh.copyfile(template_path, file_path_out)

def clean_book_structure(book_structure):
    book_structure = book_structure["book"]
    keys = ["chapters", "appendices"]
    for key in book_structure.copy():
        if key not in keys:
            book_structure.pop(key)
    return book_structure

def get_book_structure(book_yaml_path):
    with open(book_yaml_path) as f:
        book_structure = dict(yaml.safe_load(f))
    return clean_book_structure(book_structure)

def check_line(line: str):
    if "---" in line:
        return "\n"
    if "title" in line:
        if '"' in line:
            return "## " + line[line.find('"') + 1:-2]
        else:
            return "## " + line[line.find("'") + 1:-2]

    ptrn_1 = re.compile("^#")
    if ptrn_1.match(line) and ":" not in line:
        return re.sub(ptrn_1, "###", line)

    return line

def remove_source_block(lines: list):
    for idx, line in enumerate(lines.copy()):
        if "source(here::here(" in line:

            start = idx; cnd = True
            while cnd:
                start -= 1
                if "```{r}" in lines[start]: cnd = False

            end = idx; cnd = True
            while cnd:
                end += 1
                if "```" in lines[end]: cnd = False

            for idx2 in range(start, (end + 1)):
                lines[idx2] = ""

        if line == "\n\n":
            lines[idx] = "\n"
        if line == "\n" and lines[idx-1] == "\n":
            lines[idx] = ""
    return lines

book_structure = get_book_structure(book_yaml_path)

for part in book_structure["chapters"]:
    if isinstance(part, dict):
        title = part["part"]
        with open(file_path_out, mode="a", encoding="UTF-8") as file_out:
            file_out.writelines("\n# " + title + "\n")
        for file_path_in in part["chapters"]:
            file_path_in = root_path.joinpath(file_path_in)
            lines = []
            if file_path_in.exists():
                with open(file_path_in) as file_in:
                    for idx, line in enumerate(file_in):
                        line = check_line(line)
                        lines.append(line)
                lines = remove_source_block(lines)
                with open(file_path_out, mode="a", encoding="UTF-8") as file_out:
                    file_out.writelines(lines)

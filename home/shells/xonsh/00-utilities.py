from typing import Callable, Optional


def confirm(prompt: str, default: Optional[bool] = None):
    options = {None: "y/n", True: "Y/n", False: "y/N"}[default]
    prompt = f"{prompt} [{options}]: "
    results = {"y": True, "n": False}
    if default is not None:
        results[""] = default

    while True:
        selection = input(prompt).lower().strip()
        if selection in results.keys():
            return results[selection]


def select[T](
    options: list[T],
    prompt: str = "Select: ",
    to_string: Callable[[T], str] = str,
) -> T:
    digits = len(str(len(options)))

    for index, option in enumerate(options):
        print(f"{index + 1:>{digits}}: {to_string(option)}")

    selection = None
    while selection is None:
        try:
            selection = int(input(prompt))
            if selection < 1 or selection > len(options):
                selection = None
        except ValueError:
            pass

    return options[selection]

from typing import Optional

from dateutil.parser import parse as parse_date

SECOND = 1
MINUTE = 60 * SECOND
HOUR = 60 * MINUTE
DAY = 24 * HOUR
WEEK = 7 * DAY


def format_time_unit(unit, amount, short: bool = False):
    ending = "s" * (amount != 1)
    match unit:
        case "day":
            return f"{amount}d" if short else f"{amount} day" + ending
        case "hour":
            return f"{amount}h" if short else f"{amount} hour" + ending
        case "minute":
            return f"{amount}m" if short else f"{amount} minute" + ending
        case "second":
            return f"{amount}s" if short else f"{amount} second" + ending


def timedelta_str(delta, short: bool = False, separator: Optional[str] = None):
    parts = {
        "day": delta.days,
        "hour": delta.seconds // HOUR,
        "minute": (delta.seconds % HOUR) // MINUTE,
        "second": delta.seconds % MINUTE,
    }

    separator = separator or " " if short else ", "

    output = []
    for unit, amount in parts.items():
        if amount:
            output.append(format_time_unit(unit, amount, short))

    return separator.join(output)


def time_between(first: str, second: str, short: bool = False):
    delta = parse_date(second) - parse_date(first)

    return timedelta_str(delta, short)

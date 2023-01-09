"""
Infinidoge's Qtile Configuration

Sets up
- Keybindings
- Widgets
- Screens
"""
import os

from typing import List, Any  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


LAPTOP = os.getenv("LAPTOP", False)

colors = [
    # panel background
    ["#282c34", "#282c34"],  # 0
    # background for current screen tab
    ["#3d3f4b", "#434758"],  # 1
    # font color for group names
    ["#ffffff", "#ffffff"],  # 2
    # border line color for current tab
    ["#ff5555", "#ff5555"],  # 3
    # border line color for 'other tabs' and color for 'odd widgets'
    ["#74438f", "#74438f"],  # 4
    # color for the 'even widgets'
    ["#4f76c7", "#4f76c7"],  # 5
    # window name
    ["#e1acff", "#e1acff"],  # 6
    # background for inactive screens
    ["#ecbbfb", "#ecbbfb"],  # 7
]


class Apps:
    """
    Commonly referenced apps, such as the terminal or editor
    """

    TERMINAL = guess_terminal(preference="kitty")  # Set preference if necessary
    SHELL = "zsh"
    EDITOR = "emacsclient -c"

    @classmethod
    def terminal_command(cls, program, args=tuple(), *, terminal=None):
        """
        Returns a string of a command to open a program in the terminal, with the given arguments.
        """
        return f"{terminal or cls.TERMINAL} {' '.join(args)} -- {program}"

    @classmethod
    def shell_command(cls, command, args=tuple(), *, shell=None):
        """
        Returns a string of a command to run a command in the shell, with the given arguments.
        """
        return f'{shell or cls.SHELL} {" ".join(args)} -- "{command}"'

    @classmethod
    def open_in_terminal(cls, program, args=tuple(), *, terminal=None):
        """
        Opens a program in the terminal, with the given arguments.
        """
        return lazy.spawn(cls.terminal_command(program, args=args, terminal=terminal))

    @classmethod
    def shell_in_terminal(
        cls, command, sargs=tuple(), targs=tuple(), *, shell=None, terminal=None
    ):
        """
        Opens a program in the terminal using the shell, with the given shell and terminal arguments.
        """
        return cls.open_in_terminal(
            cls.shell_command(command, sargs, shell=shell), targs, terminal=terminal
        )

    @classmethod
    def open_in_editor(cls, file_, args=tuple()):
        """
        Opens a file in the editor, with the given arguments
        """
        return lazy.spawn(f"{cls.EDITOR} {' '.join(args)} {file_}")


class Keys:
    """
    Common modifier keys used in key configuration.
    """

    SUPER = "mod4"  # Windows key/super key
    CONTROL = "control"
    SHIFT = "shift"
    ALT = "mod1"
    ALT_GR = "mod5"
    META = None  # "mod3" # Not assigned to key yet
    CAPS_LOCK = "lock"
    NUM_LOCK = "mod2"


def run_command(*args, **kwargs):
    return os.popen(*args, **kwargs).read()


def optional_list(condition, lst):
    return lst if condition else []


# fmt: off
keys = [
    # Switch between windows
    Key(
        [Keys.SUPER], "Left",
        lazy.layout.left(),
        desc="Move focus to left",
    ),
    Key(
        [Keys.SUPER], "Right",
        lazy.layout.right(),
        desc="Move focus to right",
    ),
    Key(
        [Keys.SUPER], "Down",
        lazy.layout.down(),
        desc="Move focus down",
    ),
    Key(
        [Keys.SUPER], "Up",
        lazy.layout.up(),
        desc="Move focus up",
    ),
    Key(
        [Keys.SUPER], "space",
        lazy.layout.next(),
        desc="Move window focus to other window",
    ),

    # Switch focus of monitors
    Key(
        [Keys.SUPER, Keys.CONTROL], "1",
        lazy.to_screen(1),
        desc="Keyboard focus to left monitor"
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "2",
        lazy.to_screen(0),
        desc="Keyboard focus to middle monitor"
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "3",
        lazy.to_screen(2),
        desc="Keyboard focus to right monitor"
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL, Keys.SHIFT], "comma",
        lazy.next_screen(),
        desc="Move focus to next monitor"
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL, Keys.SHIFT], "period",
        lazy.prev_screen(),
        desc="Move focus to prev monitor"
    ),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [Keys.SUPER, Keys.SHIFT], "Left",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [Keys.SUPER, Keys.SHIFT], "Right",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key(
        [Keys.SUPER, Keys.SHIFT], "Down",
        lazy.layout.shuffle_down(),
        desc="Move window down",
    ),
    Key(
        [Keys.SUPER, Keys.SHIFT], "Up",
        lazy.layout.shuffle_up(),
        desc="Move window up",
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [Keys.SUPER, Keys.SHIFT], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [Keys.SUPER, Keys.CONTROL], "Left",
        lazy.layout.grow_left(),
        desc="Grow window to the left",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "Right",
        lazy.layout.grow_right(),
        desc="Grow window to the right",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "Down",
        lazy.layout.grow_down(),
        desc="Grow window down",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "Up",
        lazy.layout.grow_up(),
        desc="Grow window up",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "n",
        lazy.layout.normalize(),
        desc="Reset all window sizes",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "m",
        lazy.layout.maximize(),
        desc="Maximize the selected window",
    ),

    # Toggle between different layouts as defined below
    Key(
        [Keys.SUPER], "Tab",
        lazy.next_layout(),
        desc="Move forward through layouts",
    ),
    Key(
        [Keys.SUPER, Keys.SHIFT], "Tab",
        lazy.prev_layout(),
        desc="Move backward through layouts",
    ),

    # Qtile management keys (close, restart, shutdown, lock, spawn)
    Key(
        [Keys.SUPER], "w",
        lazy.window.kill(),
        desc="Kill focused window",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL, Keys.SHIFT], "f",
        lazy.window.toggle_floating(),
        desc="Toggle window's floating mode"
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "r",
        lazy.reload_config(),
        desc="Reload Qtile Configuration",
    ),
    # Key(
    #     [Keys.SUPER, Keys.CONTROL], "r",
    #     lazy.restart(),
    #     desc="Restart Qtile",
    # ),
    # Key(
    #     [Keys.SUPER, Keys.CONTROL], "q",
    #     lazy.shutdown(),
    #     desc="Shutdown Qtile",
    # ),
    Key(
        [Keys.SUPER, Keys.CONTROL], "l",
        lazy.spawn("xsecurelock"),
        desc="Lock Screen",
    ),

    # Keys for spawning commands or applications
    Key(
        [Keys.SUPER], "r",
        lazy.spawncmd(command=Apps.shell_command("%s", args=("-ic",))),
        desc="Spawn a command using a prompt widget",
    ),
    Key(
        [Keys.SUPER, Keys.SHIFT], "r",
        lazy.spawncmd(prompt="shell", command=Apps.terminal_command(Apps.shell_command("%s", args=("-ic",)), args=("--hold",))),
        desc="Spawn a command in a shell using a prompt widget",
    ),
    Key(
        [Keys.SUPER, Keys.ALT], "r",
        lazy.spawn("rofi -show drun"),
        desc="Spawn a rofi menu to select a desktop application to open",
    ),
    Key(
        [Keys.SUPER, Keys.CONTROL, Keys.SHIFT], "r",
        lazy.spawn("rofi -show run"),
        desc="Spawn something in the path",
    ),

    # Power management
    KeyChord(
        [Keys.SUPER], "p",
        [
            Key(
                [], "h",
                lazy.spawn("systemctl hibernate"),
                desc="Hibernates the system",
            ),
            Key(
                [], "s",
                lazy.spawn("systemctl suspend"),
                desc="Suspends the system",
            ),
            Key(
                [], "b",
                lazy.spawn("xset dpms force off"),
                desc="Turns off the screen",
            ),
            Key(
                [], "r",
                lazy.spawn("reboot"),
                desc="Reboots the system",
            ),
            Key(
                [], "p",
                lazy.spawn("shutdown now"),
                desc="Shuts down the system",
            ),
            Key(
                [], "l",
                lazy.spawn("kill -9 -1"),
                desc="Logs out of the system",
            ),
        ],
        name="Power",
    ),

    # Volume
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("amixer set Master 2%+"),
        desc="Raise volume",
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("amixer set Master 2%-"),
        desc="Lower volume",
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("amixer set Master toggle"),
        desc="Toggle mute",
    ),

    # Brightness
    *optional_list(
        LAPTOP,
        [
            Key(
                [], "XF86MonBrightnessUp",
                lazy.spawn("brightnessctl set +5%"),
                desc="Increase brightness",
            ),
            Key(
                [], "XF86MonBrightnessDown",
                lazy.spawn("brightnessctl set 5%-"),
                desc="Decrease brightness",
            )
        ]
    ),

    # Application shortcuts
    Key(
        [Keys.SUPER], "Return",
        lazy.spawn(Apps.TERMINAL),
        desc="Launch terminal",
    ),
    Key(
        [Keys.SUPER, Keys.ALT], "f",
        lazy.spawn("firefox --new-window"),
        desc="Start Firefox (New Window)",
    ),
    Key(
        [Keys.SUPER, Keys.ALT, Keys.CONTROL], "f",
        lazy.spawn("firefox --private-window"),
        desc="Start Firefox (New Private Window)",
    ),
    Key(
        [Keys.SUPER, Keys.ALT], "e",
        lazy.spawn(Apps.EDITOR),
        desc="Launch Emacs",
    ),
    Key(
        [Keys.SUPER, Keys.ALT, Keys.CONTROL], "e",
        lazy.spawn("doom +everywhere"),
        desc="Launch Emacs 'everywhere' window",
    ),
    Key(
        [Keys.SUPER, Keys.ALT], "d",
        lazy.spawn("discordcanary"),
        desc="Launch Discord",
    ),
    Key(
        [Keys.SUPER, Keys.ALT], "c",
        lazy.spawn("speedcrunch"),
        desc="Launch Speedcrunch",
    ),
    Key(
        [Keys.SUPER, Keys.ALT], "s",
        lazy.spawn("flameshot gui"),
        desc="Launch screenshot tool",
    ),
]
# fmt: on

groups = [
    *[Group(i) for i in "123456789"],
    Group("0", layouts=[layout.TreeTab()]),
]

for i in groups:
    keys.extend(
        [
            Key(
                [Keys.SUPER],
                i.name,
                lazy.group[i.name].toscreen(toggle=True),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [Keys.SUPER, Keys.SHIFT],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            Key(
                [Keys.SUPER, Keys.CONTROL, Keys.SHIFT],
                i.name,
                lazy.window.togroup(i.name),
                desc=f"Move focused window to group {i.name}",
            ),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack="#d75f5f"),
    layout.Max(),
    layout.TreeTab(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
]

widget_defaults = dict(font="sans", fontsize=12, padding=2, background=colors[0])
extension_defaults = widget_defaults.copy()


def create_powerline(
    widgets: List[List[Any]],
    *,
    base,
    foreground,
    backgrounds,
    sep="",
    padding=0,
    fontsize=37,
):
    """
    Takes in a list of widgets and produces a powerline-style bar as the result.
    Cycles through the provided colors and uses the provided character as a separator.

    Takes input as a list of widgets, then base, foreground, and backgrounds as keyword arguments.
    Setting sep changes the separator
    """
    output = []

    for i, widgets_list in enumerate(widgets):
        bg_index = (len(widgets) - i) % len(backgrounds)
        output.append(
            widget.TextBox(
                text=sep,
                foreground=backgrounds[bg_index],
                background=base
                if i == 0
                else backgrounds[bg_index - (len(backgrounds) - 1)],
                fontsize=fontsize,
                padding=padding,
            )
        )

        for elem in widgets_list:
            elem.foreground = foreground
            elem.background = backgrounds[bg_index]
            output.append(elem)

    return output


def init_widget_list(main=True, laptop=False):
    """
    Returns a list of widgets suitable for a qtile bar
    """

    widget_list = [
        widget.Sep(linewidth=0, padding=6, foreground=colors[2], background=colors[0]),
        widget.GroupBox(
            font="Ubuntu Mono",
            fontsize=14,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active=colors[2],
            inactive=colors[7],
            rounded=False,
            highlight_color=colors[1],
            highlight_method="line",
            this_current_screen_border=colors[5],
            this_screen_border=colors[6],
            other_current_screen_border=colors[5],
            other_screen_border=colors[4],
            foreground=colors[2],
            background=colors[0],
            use_mouse_wheel=False,
            disable_drag=True,
        ),
        widget.Chord(
            font="Ubuntu Mono",
            padding=10,
            foreground=colors[3],
            background=colors[1],
            max_chars=10,
        ),
        widget.Sep(linewidth=0, padding=6, foreground=colors[2], background=colors[0]),
        widget.Prompt(
            prompt="{prompt}: ",
            font="Ubuntu Mono",
            padding=10,
            foreground=colors[3],
            background=colors[1],
        ),
        widget.Sep(linewidth=0, padding=40, foreground=colors[2], background=colors[0]),
        widget.WindowName(foreground=colors[6], background=colors[0], padding=0),
        *optional_list(
            main,
            [
                widget.Systray(background=colors[0], padding=5),
            ],
        ),
        widget.Sep(linewidth=0, padding=6, foreground=colors[0], background=colors[0]),
        *create_powerline(
            [
                # Widgets only found on the main screen's powerline
                *optional_list(
                    main,
                    [
                        [
                            *sum(
                                [
                                    [
                                        *optional_list(
                                            i != 0,
                                            [
                                                widget.Sep(linewidth=2, padding=3),
                                            ],
                                        ),
                                        widget.TextBox(text=f"{interface}:", padding=2),
                                        widget.Net(
                                            interface=interface,
                                            format="{down} ↓↑ {up}",
                                            padding=5,
                                        ),
                                    ]
                                    for i, interface in enumerate(
                                        run_command(
                                            "ifconfig -s"
                                            " | awk {'print $1'}"
                                            " | grep -Ev -e Iface -e lo -e vir.+ -e docker.+ -e tailscale.+"
                                            " | tac"
                                        ).splitlines()
                                    )
                                ],
                                [],
                            )
                        ],
                        [
                            widget.TextBox(text="", padding=0, fontsize=24),
                            widget.Memory(padding=5),
                        ],
                        [
                            widget.TextBox(text=" Vol:", padding=0),
                            widget.Volume(padding=5),
                        ],
                        *optional_list(
                            laptop,
                            [
                                (
                                    [
                                        widget.TextBox(
                                            text=" 🔆", padding=0, fontsize=14
                                        ),
                                        widget.Backlight(
                                            backlight_name=(
                                                backlight.splitlines()[0].split(",")[0]
                                            ),
                                            change_command="brightnessctl set {0}%",
                                            step=5,
                                            padding=5,
                                        ),
                                    ]
                                    if (
                                        backlight := run_command(
                                            "brightnessctl -lm --class=backlight"
                                        )
                                    )
                                    else []
                                ),
                                [  # TODO: Create battery icon widget using NerdFont icons
                                    widget.Battery(
                                        format="{char} {percent:2.1%} {hour:d}h:{min:02d}m",
                                        update_interval=10,
                                        padding=5,
                                        charge_char="",
                                        discharge_char="",
                                    ),
                                ],
                            ],
                        ),
                    ],
                ),
                # Widgets found on the powerline of all screens
                [
                    widget.CurrentLayoutIcon(padding=0, scale=0.7),
                    widget.CurrentLayout(padding=5),
                ],
                [
                    widget.Clock(
                        format="%A, %B %d, %Y - %H:%M:%S ",
                    ),
                ],
            ],
            base=colors[0],
            foreground=colors[2],
            backgrounds=[
                colors[4],
                colors[5],
            ],
        ),
    ]

    return widget_list


screens = [
    Screen(
        bottom=bar.Bar(
            init_widget_list(main=(i == 0), laptop=LAPTOP),
            size=20,
            opacity=1.0,
        ),
        wallpaper="~/.config/qtile/images/BotanBackground.jpg",
        wallpaper_mode="fill",
    )
    for i in range(
        int(run_command("xrandr --listmonitors | grep 'Monitors:' | awk {'print $2'}"))
    )
]

# Drag floating layouts.
mouse = [
    Drag(
        [Keys.SUPER],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [Keys.SUPER],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click(
        [Keys.SUPER],
        "Button2",
        lazy.window.bring_to_front(),
    ),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        # Section taken from Default Float Rules
        Match(wm_type="utility"),
        Match(wm_type="notification"),
        Match(wm_type="toolbar"),
        Match(wm_type="splash"),
        Match(wm_type="dialog"),
        Match(wm_class="file_progress"),
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(func=lambda c: c.has_fixed_size()),
        Match(func=lambda c: c.has_fixed_ratio()),
        # End section
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="pinentry"),
    ]
)


dgroups_key_binder = None
dgroups_app_rules = []  # type: List

follow_mouse_focus = True
bring_front_click = False
cursor_warp = True
auto_fullscreen = True
focus_on_window_activation = "never"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

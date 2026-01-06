{ main, ... }:

{
  services.dunst = {
    enable = main.info.graphical;
    settings = {
      global = {
        width = "(300,400)";
        height = "(50,250)";
        offset = "(30,50)";
        origin = "bottom-right";
        transparency = 10;
        frame_color = "#33ddff";

        idle_threshold = 300;
        follow = "mouse";
        enable_posix_regex = true;
      };
      urgency_low = {
        background = "#222222";
        foreground = "#dddddd";
        timeout = 10;
      };
      urgency_normal = {
        background = "#225577";
        timeout = 20;
      };
      urgency_critical = {
        background = "#ee2222";
        foreground = "#ffffff";
        timeout = 0;
      };
    };
  };
}

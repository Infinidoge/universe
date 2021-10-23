{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    font = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
      size = 12;
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita-Dark";
    };

    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-Dark";
    };
  };

  qt = {
    enable = true;
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };
}

{ config, main, pkgs, lib, ... }:
{
  services.flameshot = {
    enable = main.info.graphical;
    settings = {
      General = {
        buttons = "@Variant(\\0\\0\\0\\x7f\\0\\0\\0\\vQList<int>\\0\\0\\0\\0\\x18\\0\\0\\0\\0\\0\\0\\0\\x1\\0\\0\\0\\x2\\0\\0\\0\\x3\\0\\0\\0\\x4\\0\\0\\0\\x5\\0\\0\\0\\x6\\0\\0\\0\\x12\\0\\0\\0\\x13\\0\\0\\0\\xf\\0\\0\\0\\x16\\0\\0\\0\\a\\0\\0\\0\\b\\0\\0\\0\\t\\0\\0\\0\\x10\\0\\0\\0\\n\\0\\0\\0\\v\\0\\0\\0\\f\\0\\0\\0\\r\\0\\0\\0\\xe\\0\\0\\0\\x11\\0\\0\\0\\x14\\0\\0\\0\\x15\\0\\0\\0\\x17)";

        contrastOpacity = 188;
        contrastUiColor = "#000070";
        drawColor = "#00ffff";
        uiColor = "#2e86cf";

        disabledTrayIcon = true;
        showDesktopNotification = false;
        showHelp = true;
        showStartupLaunchMessage = false;
        startupLaunch = false;

        undoLimit = 100;
        uploadHistoryMax = 25;

        savePath = "/home/infinidoge/Pictures";
        saveAsFileExtension = ".png";
        filenamePattern = "%F_%T";
        saveAfterCopy = false;
        savePathFixed = true;
      };
    };
  };
}

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        buttons = "@Invalid()";

        contrastOpacity = 188;
        contrastUiColor = "#000070";
        drawColor = "#00ffff";
        uiColor = "#2e86cf";

        disabledTrayIcon = true;
        showDesktopNotification = false;
        showHelp = true;
        showStartupLaunchMessage = false;
        startupLaunch = false;

        # BUG: https://github.com/NixOS/nixpkgs/pull/518301

        captureActiveMonitor = true;
        useX11LegacyScreenshot = true;

        undoLimit = 100;
        uploadHistoryMax = 25;

        savePath = "/home/infinidoge/screenshots";
        saveAsFileExtension = ".png";
        filenamePattern = "%F_%T";
        saveAfterCopy = true;
        savePathFixed = true;

        userColors = "picker, #800000, #ff0000, #ffff00, #00ff00, #008000, #00ffff, #0000ff, #ff00ff, #3498db, #8f247a, #202020, #5dbdbd";
      };
    };
  };
}

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

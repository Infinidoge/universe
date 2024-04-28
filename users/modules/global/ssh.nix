{ ... }: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "1m";
    matchBlocks = {
      "server.doge-inc.net" = {
        port = 245;
      };
    };
  };
}

{ ... }: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "1m";
    forwardAgent = true;
    matchBlocks = { };
  };
}

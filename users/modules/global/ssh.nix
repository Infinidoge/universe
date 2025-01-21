{ ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "1m";
    matchBlocks = {
      "server.doge-inc.net" = {
        port = 245;
      };
    };
  };

  services.ssh-agent.enable = true;
}

{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      controlMaster = "auto";
      controlPersist = "1m";
    };
  };

  services.ssh-agent.enable = true;
}

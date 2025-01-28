{ ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "1m";
  };

  services.ssh-agent.enable = true;
}

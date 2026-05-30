{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      EnableEscapeCommandline yes
    '';
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };

  services.ssh-agent.enable = true;
}

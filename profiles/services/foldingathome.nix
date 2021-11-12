{ pkgs, ... }: {
  services.foldingathome = {
    enable = true;
    user = "Infinidoge";
    daemonNiceLevel = 10;
  };

  environment.systemPackages = with pkgs; [
    fahcontrol
    fahviewer
  ];
}

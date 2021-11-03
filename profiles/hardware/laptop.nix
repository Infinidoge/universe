{ pkgs, ... }: {
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  environment.variables.LAPTOP = "True";

  services.logind.lidSwitch = "ignore";

  environment.systemPackages = with pkgs; [ acpi ];
}

{ pkgs, ... }:
{
  # ENABLE: wireless, audio, yubikey, media

  hardware = {
    acpilight.enable = true;
  };

  services = {
    libinput.touchpad = {
      clickMethod = "clickfinger";
      naturalScrolling = true;
    };

    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "ignore";
    };

    tlp.enable = true;

    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };
  };

  powerManagement = {
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  environment = {
    variables.LAPTOP = "True";
    systemPackages = with pkgs; [
      acpi
      brightnessctl
      powertop
    ];
  };
}

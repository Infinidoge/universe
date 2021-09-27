{ ... }: {
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  environment.variables.LAPTOP = "True";
}

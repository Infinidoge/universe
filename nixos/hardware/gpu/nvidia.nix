{
  pkgs,
  config,
  options,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      libva-vdpau-driver

      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia.open = true;

  # BUG: https://github.com/NixOS/nixpkgs/issues/467814
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  programs.steam.package = options.programs.steam.package.default.override {
    extraProfile = ''
      unset VK_ICD_FILENAMES
      export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
    '';
  };
}

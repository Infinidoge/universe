{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      libva-vdpau-driver
      vpl-gpu-rt

      intel-ocl
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };
}

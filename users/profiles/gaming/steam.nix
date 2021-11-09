{ pkgs, main, ... }: {
  home.packages = with pkgs; [
    (steam.override {
      extraLibraries = pkgs: with pkgs; [ pipewire ];
      extraProfile = ''
        unset VK_ICD_FILENAMES
        export VK_ICD_FILENAMES=${main.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${main.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
      '';
    })

    protonup
  ];
}

{ ... }:
{
  virtualisation.xen = {
    enable = true;
    boot.builderVerbosity = "info";
    boot.params = [
      "vga=ask" # Useful for non-headless systems with screens bigger than 640x480.
      "dom0=pvh" # Uses the PVH virtualisation mode for the Domain 0, instead of PV.
    ];
  };

  persist.directories = [
    "/var/lib/xen"
  ];
}

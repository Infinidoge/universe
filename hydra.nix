{ self, lib, ... }:

let
  filterBroken = _: lib.filterAttrs (n: v: v ? meta -> v.meta ? broken -> !v.meta.broken);

  getTopLevel = (name: { toplevel = self.nixosConfigurations.${name}.config.system.build.toplevel; });
in
{
  flake.hydraJobs = {
    packages = lib.mapAttrs filterBroken self.packages;
    nixosConfigurations.x86_64-linux = lib.flip lib.genAttrs getTopLevel [
      "apophis"
      "artemis"
      "bacchus"
      "daedalus"
      "dionysus"
      #"hermes"
      "hestia"
      "iris"
      "lethe"
      "pluto"
    ];
  };
}

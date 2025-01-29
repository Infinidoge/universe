{ self, lib, ... }:

let
  isBroken = _: lib.filterAttrs (n: v: v ? meta -> v.meta ? broken -> !v.meta.broken);

  getTopLevel = (name: { toplevel = self.nixosConfigurations.${name}.config.system.build.toplevel; });
in
{
  flake.hydraJobs = {
    packages = lib.mapAttrs isBroken self.packages;
    nixosConfigurations.x86_64-linux = lib.flip lib.genAttrs getTopLevel [
      "Infini-DESKTOP"
      "Infini-DL360"
      "Infini-FRAMEWORK"
      "Infini-OPTIPLEX"
      "Infini-SERVER"
      "hermes"
      "hestia"
    ];
  };
}

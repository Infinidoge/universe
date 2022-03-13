final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  fetchModrinthMod = final.callPackage (import ./fabric-mods/fetchModrinthMod.nix);

  fabric-server = final.callPackage (import ./fabric-server) { };
}

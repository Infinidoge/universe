final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  fabric-server = final.callPackage (import ./fabric-server) { };

  discord-canary-new = final.callPackage (import ./discord) { branch = "canary"; };

}

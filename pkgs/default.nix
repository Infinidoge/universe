final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`

  kmscon = prev.kmscon.overrideAttrs (old: {
    version = "unstable-2022-04-28";
    src = final.sources.kmscon.src;
  });
}

{ lib, stdenv }:

{ name, symlinks }:
let
  normalized = lib.mapAttrs' (n: v: lib.nameValuePair (lib.path.subpath.normalise n) "${v}") symlinks;
  linkCommands = lib.mapAttrsToList
    (n: v: ''
      mkdir -p $out/$(dirname ${n})
      ln -s ${v} $out/${n}
    '')
    normalized;
in
stdenv.mkDerivation {
  name = "firefox";
  phases = [ "installPhase" ];
  preferLocalBuild = true;
  allowSubstitutes = false;
  installPhase = ''
    mkdir $out

    ${lib.concatStringsSep "\n" linkCommands}
  '';
}

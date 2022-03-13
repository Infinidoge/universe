{ stdenv, fetchurl, id, responseHash }:
let
  version = (builtins.fromJSON (builtins.readFile (fetchurl { url = "https://api.modrinth.com/v2/version/${id}"; sha256 = responseHash; })));
  file = (builtins.elemAt version.files 0);
in
fetchurl { url = file.url; sha512 = file.hashes.sha512; }

{ fetchurl }:
fetchurl rec {
  pname = "unsup";
  version = "1.2.0-pre1";
  name = "${pname}-${version}.jar";

  url = "https://git.sleeping.town/unascribed/unsup/releases/download/v${version}/${name}";
  hash = "sha256-OLTHM6haMNJ34rh7N1eBKjyPB7lS541wjTBSl4aLIoc=";
}

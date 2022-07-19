{ buildGo118Module
, source
}:
buildGo118Module rec {
  inherit (source) pname version src;
  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
}

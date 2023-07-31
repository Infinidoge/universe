inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};

  latest = mkPkgs inputs.latest;
  fork = mkPkgs inputs.fork;
in
{
  inherit (latest)
    ;

  inherit (fork)
    ;
}

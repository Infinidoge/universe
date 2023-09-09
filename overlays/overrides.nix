inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};

  latest = mkPkgs inputs.latest;
  fork = mkPkgs inputs.fork;
  stable = mkPkgs inputs.stable;
in
{
  inherit (latest)
    ;

  inherit (fork)
    ;

  inherit (stable)
    ;
}

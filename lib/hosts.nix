{ lib }:

{
  mkHost = attrs@{ modules ? [ ], ... }: name: path: lib.nixosSystem (attrs // {
    modules = [
      {
        networking.hostName = lib.mkDefault name;
      }
      (import path)
    ] ++ attrs.modules;
  });
}

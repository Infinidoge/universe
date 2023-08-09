{ self, lib, ... }:

{
  perSystem = { pkgs, ... }: {
    devshells.default =
      let
        pythonEnv = (pkgs.python310.withPackages (p: with p; [
          pkgs.qtile.passthru.unwrapped
        ]));
      in
      {
        name = "universe";

        devshell.packages = [
          pythonEnv
        ];

        env = [
          {
            name = "PYTHONPATH";
            value = "${pythonEnv}/${pythonEnv.sitePackages}";
          }
        ];
      };
  };
}

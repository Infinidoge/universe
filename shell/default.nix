{ self, lib, ... }:

{
  perSystem = { pkgs, inputs', ... }: {
    devshells.default =
      let
        pythonEnv = (pkgs.python311.withPackages (p: with p; [
          pkgs.qtile.passthru.unwrapped
        ]));
      in
      {
        devshell.name = "universe";
        devshell.motd = "";

        devshell.packages = [
          pythonEnv
          inputs'.disko.packages.disko
        ];

        env = [
          { name = "PYTHONPATH"; value = "${pythonEnv}/${pythonEnv.sitePackages}"; }
        ];
      };
  };
}

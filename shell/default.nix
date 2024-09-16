{ self, lib, ... }:

{
  perSystem = { pkgs, inputs', ... }: {
    devshells.default =
      let
        pythonEnv = (pkgs.python3.withPackages (p: with p; [
          qtile
          qtile-extras
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
          { name = "PYTHONPATH"; prefix = "${pythonEnv}/${pythonEnv.sitePackages}"; }
        ];
      };
  };
}

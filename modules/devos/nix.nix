{ config, channel, inputs, pkgs, lib, self, ... }:
with lib;
{
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      allowed-users = [ "@wheel" ];

      trusted-users = [ "root" "@wheel" ];

      system-feature = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

      auto-optimise-store = true;

      sandbox = true;
    };

    gc.automatic = true;

    optimise.automatic = true;

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

    nixPath = [
      "nixpkgs=${channel.input}"
      "nixos-config=${../../lib/compat/nixos}"
      "home-manager=${inputs.home}"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };


  environment = {
    systemPackages = with pkgs; [ nix-index nixfmt nixpkgs-fmt ];

    shellAliases =
      let ifSudo = mkIf config.security.sudo.enable;
      in
      {
        # nix
        n = "nix";
        np = "n profile";
        ni = "np install";
        nr = "np remove";
        ns = "n search --no-update-lock-file";
        nf = "n flake";
        nepl = "n repl '<nixpkgs>'";
        srch = "ns nixos";
        nrb = ifSudo "sudo nixos-rebuild";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # fix nixos-option
        nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
      };
  };
}

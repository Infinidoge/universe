{ config, channel, inputs, pkgs, lib, self, ... }:
with lib;
{
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      allowed-users = [ "@wheel" ];

      trusted-users = [ "root" "@wheel" ];

      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

      auto-optimise-store = true;

      sandbox = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      dates = "weekly";
    };

    optimise.automatic = true;

    registry =
      let
        flakes = filterAttrs (n: v: v ? outputs) inputs;
      in
      (mapAttrs' (n: v: { name = if n == "self" then "universe" else n; value = { flake = v; }; }) flakes)
      // {
        nixpkgs-git = {
          exact = false;
          from.id = "local";
          from.type = "indirect";
          to.url = "file:///nix/nixpkgs";
          to.type = "git";
        };
      };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
    ];

    extraOptions = ''
      flake-registry = ${inputs.flake-registry}/flake-registry.json

      extra-experimental-features = flakes nix-command
      extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
      extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=

      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '' + (optionalString config.modules.secrets.enable ''
      secret-key-files = ${config.secrets.binary-cache-private-key}
    '');
  };

  nixpkgs.config = {
    allowUnfree = true;
  };


  environment = {
    systemPackages = with pkgs; [
      nix-index
      nixos-option
      nixfmt
      nixpkgs-fmt
      nix-du
      comma

      (writeScriptBin "wherenix" ''
        #!/usr/bin/env bash
        ${unixtools.whereis}/bin/whereis "''${@}" \
        | ${gawk}/bin/awk '{ print substr($0, length($1)+2) }' \
        | ${findutils}/bin/xargs -r ${coreutils}/bin/readlink -f \
        | ${coreutils}/bin/sort \
        | ${coreutils}/bin/uniq
      '')
    ];

    shellAliases =
      let ifSudo = mkIf config.security.sudo.enable;
      in
      {
        # nix
        n = "nix";
        ns = "n search --no-update-lock-file";
        nf = "n flake";
        nepl = "n repl '<nixpkgs>'";
        srch = "ns nixpkgs";
        nrb = ifSudo "sudo nixos-rebuild";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # fix nixos-option
        # nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
      };
  };
}

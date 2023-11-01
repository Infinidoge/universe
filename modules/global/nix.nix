{ config, channel, inputs, pkgs, lib, self, ... }:
with lib;
{
  nix = {
    package = pkgs.nixVersions.nix_2_17;

    settings = {
      allowed-users = [ "*" ];
      trusted-users = [ "root" "@wheel" ];

      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      experimental-features = [ "flakes" "nix-command" "impure-derivations" "no-url-literals" "repl-flake" ];

      auto-optimise-store = true;

      sandbox = true;
      use-xdg-base-directories = true;
      keep-outputs = true;
      keep-derivations = true;
      fallback = true;

      flake-registry = "${inputs.flake-registry}/flake-registry.json";
      secret-key-files = mkIf config.modules.secrets.enable config.secrets.binary-cache-private-key;

      min-free = 536870912; # 0.5 gibi bytes
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
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
  };

  nixpkgs.config = {
    allowUnfree = true;
  };


  environment = {
    systemPackages = with pkgs; [
      comma
      nix-diff
      nix-du
      nix-index
      nix-tree
      nixfmt
      nixpkgs-fmt

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
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';
      };
  };
}
